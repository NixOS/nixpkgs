{ lib, stdenv, cleanPackaging, fetchurl }:
{
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
  # : string
, postConfigure ? null
  # mostly for moving and deleting files from the build directory
  # : lines
, postInstall
  # : list Maintainer
, maintainers ? [ ]
  # : passtrhu arguments (e.g. tests)
, passthru ? { }

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
    "DCO"
    "CONTRIBUTING"
  ];

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://skarnet.org/software/${pname}/${pname}-${version}.tar.gz";
    inherit sha256;
  };

  inherit outputs;

  dontDisableStatic = true;
  enableParallelBuilding = true;

  configureFlags = configureFlags ++ [
    "--enable-absolute-paths"
    # We assume every nix-based cross target has urandom.
    # This might not hold for e.g. BSD.
    "--with-sysdep-devurandom=yes"
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

  inherit postConfigure;

  makeFlags = lib.optional stdenv.cc.isClang [ "AR=${stdenv.cc.targetPrefix}ar" "RANLIB=${stdenv.cc.targetPrefix}ranlib" ];

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
    license = lib.licenses.isc;
    maintainers = with lib.maintainers;
      [ pmahoney Profpatsch qyliss ] ++ maintainers;
  };

  inherit passthru;

}
