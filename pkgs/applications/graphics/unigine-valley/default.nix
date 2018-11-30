{ stdenv, fetchurl

# Build-time dependencies
, makeWrapper
, file

# Runtime dependencies
, fontconfig
, freetype
, libX11
, libXext
, libXinerama
, libXrandr
, libXrender
, openal}:

let
  version = "1.0";

  arch = if stdenv.hostPlatform.system == "x86_64-linux" then
    "x64"
  else if stdenv.hostPlatform.system == "i686-linux" then
    "x86"
  else
    throw "Unsupported platform ${stdenv.hostPlatform.system}";

in
  stdenv.mkDerivation rec {
    name = "unigine-valley-${version}";

    src = fetchurl {
      url = "http://assets.unigine.com/d/Unigine_Valley-${version}.run";
      sha256 = "5f0c8bd2431118551182babbf5f1c20fb14e7a40789697240dcaf546443660f4";
    };

    sourceRoot = "Unigine_Valley-${version}";
    instPath = "lib/unigine/valley";

    buildInputs = [file makeWrapper];

    libPath = stdenv.lib.makeLibraryPath [
      stdenv.cc.cc  # libstdc++.so.6
      fontconfig
      freetype
      libX11
      libXext
      libXinerama
      libXrandr
      libXrender
      openal
    ];

    unpackPhase = ''
      runHook preUnpack

      cp $src extractor.run
      chmod +x extractor.run
      ./extractor.run --target $sourceRoot

      runHook postUnpack
    '';

    patchPhase = ''
      runHook prePatch

      # Patch ELF files.
      elfs=$(find bin -type f | xargs file | grep ELF | cut -d ':' -f 1)
      for elf in $elfs; do
        patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 $elf || true
      done

      runHook postPatch
    '';

    installPhase = ''
      runHook preInstall

      instdir=$out/${instPath}

      # Install executables and libraries
      mkdir -p $instdir/bin
      install -m 0755 bin/browser_${arch} $instdir/bin
      install -m 0755 bin/libApp{Stereo,Surround,Wall}_${arch}.so $instdir/bin
      install -m 0755 bin/libGPUMonitor_${arch}.so $instdir/bin
      install -m 0755 bin/libQt{Core,Gui,Network,WebKit,Xml}Unigine_${arch}.so.4 $instdir/bin
      install -m 0755 bin/libUnigine_${arch}.so $instdir/bin
      install -m 0755 bin/valley_${arch} $instdir/bin
      install -m 0755 valley $instdir

      # Install other files
      cp -R data documentation $instdir

      # Install and wrap executable
      mkdir -p $out/bin
      install -m 0755 valley $out/bin/valley
      wrapProgram $out/bin/valley \
        --run "cd $instdir" \
        --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:$instdir/bin:$libPath

      runHook postInstall
    '';

    stripDebugList = ["${instPath}/bin"];

    meta = {
      description = "The Unigine Valley GPU benchmarking tool";
      homepage = http://unigine.com/products/benchmarks/valley/;
      license = stdenv.lib.licenses.unfree; # see also: $out/$instPath/documentation/License.pdf
      maintainers = [ stdenv.lib.maintainers.kierdavis ];
      platforms = ["x86_64-linux" "i686-linux"];
    };
  }
