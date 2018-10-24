{ stdenv, fetchurl, writeScript, file }:
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

  globWith = stdenv.lib.concatMapStringsSep "\n";
  rmNoise = globWith (f:
    ''rm -rf ${f}'') commonNoiseFiles;
  mvMeta = globWith
    (f: ''mv ${f} "$DOCDIR" 2>/dev/null || true'')
    commonMetaFiles;

  # Move & remove actions, taking the package doc directory
  commonFileActions = writeScript "common-file-actions.sh" ''
    #!${stdenv.shell}
    set -e
    DOCDIR="$1"
    shopt -s globstar extglob nullglob
    ${rmNoise}
    mkdir -p "$DOCDIR"
    ${mvMeta}
  '';


in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://skarnet.org/software/${pname}/${pname}-${version}.tar.gz";
    inherit sha256;
  };

  inherit outputs;

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
    mkdir -p $doc/share/doc/${pname}
    ${commonFileActions} $doc/share/doc/${pname}

    ${postInstall}
  '';

  postFixup = ''
    echo "Checking for remaining source files"
    rem=$(find -mindepth 1 -xtype f -print0 \
           | tee $TMP/remaining-files)
    if [[ "$rem" != "" ]]; then
      echo "ERROR: These files should be either moved or deleted:"
      cat $TMP/remaining-files | xargs -0 ${file}/bin/file
      exit 1
    fi
  '';

  meta = {
    homepage = "https://skarnet.org/software/${pname}/";
    inherit description platforms;
    license = stdenv.lib.licenses.isc;
    maintainers = with lib.maintainers;
      [ pmahoney Profpatsch ] ++ maintainers;
  };

}
