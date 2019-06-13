{ stdenv, callPackage, cleanPackaging, fetchurl, writeScript, file }:
let lib = stdenv.lib;
in {
  # : string
  pname
  # : string
, version
  # : string
, sha256
  # : string
, description
  # : list Platform
, platforms ? lib.platforms.all
  # : list string
, outputs ? [ "bin" "lib" "dev" "doc" "out" ]
  # TODO(Profpatsch): automatically infer most of these
  # : list string
, configureFlags
  # mostly for moving and deleting files from the build directory
  # : lines
, postInstall
  # packages with setup hooks that should be run
  # (see definition of `makeSetupHook`)
  # : list drv
, setupHooks ? []
  # : list Maintainer
, maintainers ? []


}:

let

  # File globs that can always be deleted
  commonNoiseFiles = [
    ".gitignore"
    "Makefile"
    "INSTALL"
    "configure"
    "patch-for-solaris"
    "src/**/*"
    "tools/**/*"
    "package/**/*"
    "config.mak"
  ];

  # File globs that should be moved to $doc
  commonMetaFiles = [
    "COPYING"
    "AUTHORS"
    "NEWS"
    "CHANGELOG"
    "README"
    "README.*"
  ];

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://skarnet.org/software/${pname}/${pname}-${version}.tar.gz";
    inherit sha256;
  };

  inherit outputs;

  dontDisableStatic = true;
  enableParallelBuilding = true;

  nativeBuildInputs = setupHooks;

  configureFlags = configureFlags ++ [
    "--enable-absolute-paths"
    (if stdenv.isDarwin
      then "--disable-shared"
      else "--enable-shared")
  ]
    # On darwin, the target triplet from -dumpmachine includes version number,
    # but skarnet.org software uses the triplet to test binary compatibility.
    # Explicitly setting target ensures code can be compiled against a skalibs
    # binary built on a different version of darwin.
    # http://www.skarnet.org/cgi-bin/archive.cgi?1:mss:623:heiodchokfjdkonfhdph
    ++ (lib.optional stdenv.isDarwin
         "--build=${stdenv.hostPlatform.system}");

  # TODO(Profpatsch): ensure that there is always a $doc output!
  postInstall = ''
    echo "Cleaning & moving common files"
    ${cleanPackaging.commonFileActions {
       noiseFiles = commonNoiseFiles;
       docFiles = commonMetaFiles;
     }} $doc/share/doc/${pname}

    ${postInstall}
  '';

  postFixup = ''
    ${cleanPackaging.checkForRemainingFiles}
  '';

  meta = {
    homepage = "https://skarnet.org/software/${pname}/";
    inherit description platforms;
    license = stdenv.lib.licenses.isc;
    maintainers = with lib.maintainers;
      [ pmahoney Profpatsch ] ++ maintainers;
  };

}
