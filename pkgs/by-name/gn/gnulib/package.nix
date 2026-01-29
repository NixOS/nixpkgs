{
  lib,
  stdenv,
  fetchgit,
  python3,
  perl,
}:

stdenv.mkDerivation {
  pname = "gnulib";
  version = "20251214";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/gnulib.git";
    rev = "b6d56475ad6d8bc59e85cdf7fa8dd60fbddc6ffc";
    hash = "sha256-tLkUZvTdRSlDJ54w63/z/wiMVBZbqBuHw87kEN01MRs=";
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

  passthru.patches = {
    memcpy-fix = ./memcpy-fix.patch;
    memcpy-fix-backport-250512 = ./memcpy-fix-backport-250512.patch;
  };

  meta = {
    description = "Central location for code to be shared among GNU packages";
    homepage = "https://www.gnu.org/software/gnulib/";
    changelog = "https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=blob;f=ChangeLog";
    license = lib.licenses.gpl3Plus;
    mainProgram = "gnulib-tool";
    platforms = lib.platforms.unix;
  };
}
