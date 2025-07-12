{
  lib,
  stdenv,
  fetchurl,
  python3,
  perl,
}:

stdenv.mkDerivation {
  pname = "gnulib";
  version = "20241001";

  # Use the coreutils mirror so we can fetch a tarball for bootstrapping reasons.
  # (The official source is only available via git.)
  src = fetchurl {
    url = "https://github.com/coreutils/gnulib/archive/d70f5b940c486b2cc49027ec5f057bdce9b907c5.tar.gz";
    hash = "sha256-sOO9uNxGX8YSILzqCmNAQcp9AYcJDYd3OYgOLgK8/yw=";
  };

  postPatch = ''
    patchShebangs gnulib-tool.py
    substituteInPlace build-aux/{prefix-gnulib-mk,useless-if-before-free,update-copyright,gitlog-to-changelog,announce-gen} \
    --replace-fail 'exec perl' 'exec ${lib.getExe perl}'
  '';

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
    ln -s $out/lib $out/include
    ln -s $out/gnulib-tool $out/bin/
  '';

  # do not change headers to not update all vendored build files
  dontFixup = true;

  meta = with lib; {
    description = "Central location for code to be shared among GNU packages";
    homepage = "https://www.gnu.org/software/gnulib/";
    changelog = "https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=blob;f=ChangeLog";
    license = licenses.gpl3Plus;
    mainProgram = "gnulib-tool";
    platforms = platforms.unix;
  };
}
