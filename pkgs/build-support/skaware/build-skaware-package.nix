{ stdenv, cleanPackaging, fetchurl }:
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
, postInstall ? ""
  # : lines
, postFixup ? ""
  # : list Maintainer
, maintainers ? []
  # : attrs
, meta ? {}
, ...
} @ args:

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

in stdenv.mkDerivation ({
  src = fetchurl {
    url = "https://skarnet.org/software/${pname}/${pname}-${version}.tar.gz";
    inherit sha256;
  };

  dontDisableStatic = true;
  enableParallelBuilding = true;

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
  '' + postInstall;

  postFixup = ''
    ${cleanPackaging.checkForRemainingFiles}
  '' + postFixup;

  meta = {
    homepage = "https://skarnet.org/software/${pname}/";
    inherit description platforms;
    license = stdenv.lib.licenses.isc;
    maintainers = with lib.maintainers;
      [ pmahoney Profpatsch ] ++ maintainers;
  } // meta;

} // builtins.removeAttrs args [
  "sha256" "configureFlags" "postInstall" "postFixup"
  "meta" "description" "platforms"  "maintainers"
])
