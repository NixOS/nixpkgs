{ depname
, version
, src
, sourceRoot
, stdenv
, lib
, patches ? []
, extraPostPatch ? ""
, buildInputs ? []
}:

let
  rebuildscriptName = if stdenv.hostPlatform.isLinux then
    "build_linux"
  else if stdenv.hostPlatform.isDarwin then
    "build_macos"
  else throw "Don't know how to rebuild FamiStudio's vendored ${depname} for ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  pname = "famistudio-nativedep-${depname}";
  inherit version src sourceRoot patches buildInputs;

  postPatch = let
    libnameBase = lib.optionalString stdenv.hostPlatform.isLinux "lib" + depname;
  in ''
    # Use one name for build script, eases with patching
    mv ${rebuildscriptName}.sh build.sh

    # Scripts use hardcoded compilers and try to copy built libraries into FamiStudio's build tree
    # Not all scripts use the same compiler, so don't fail on replacing that
    substituteInPlace build.sh \
      --replace-fail '../../FamiStudio/' "$out/lib/" \
      --replace-quiet 'g++' "$CXX"

    # Replacing gcc via sed, would break -static-libgcc otherwise
    sed -i -e "s/^gcc/$CC/g" build.sh
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Darwin rebuild scripts try to make a universal2 dylib
    # - build dylib for non-hostPlatform
    # - copy built library into special directory for later packaging script
    # - join two dylibs together into a universal2 dylib
    # Remove everything we don't need
    sed -ri \
      -e '/-target ${if stdenv.hostPlatform.isx86_64 then "arm64" else "x86_64"}/d' \
      -e '/..\/..\/Setup/d' \
      build.sh

    # Replace joining multi-arch dylibs with copying dylib for target arch
    substituteInPlace build.sh \
      --replace-fail 'lipo -create -output ${libnameBase}.dylib' 'cp ${libnameBase}_${if stdenv.hostPlatform.isx86_64 then "x86_64" else "arm64"}.dylib ${libnameBase}.dylib #'
  '' + extraPostPatch;

  dontConfigure = true;
  dontInstall = true; # rebuild script automatically installs

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/lib

    # Delete all prebuilt libraries, make sure everything is rebuilt
    find . -name '*.so' -or -name '*.dylib' -or -name '*.a' -delete

    # When calling normally, an error won't cause derivation to fail
    source ./build.sh

    runHook postBuild
  '';
}
