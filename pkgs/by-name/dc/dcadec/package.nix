{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dcadec";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "foo86";
    repo = "dcadec";
    rev = "v" + finalAttrs.version;
    sha256 = "07nd0ajizrp1w02bsyfcv18431r8m8rq8gjfmz9wmckpg7cxj2hs";
  };

  installPhase = "make PREFIX=/ DESTDIR=$out install";

  doCheck = false; # fails with "ERROR: Run 'git submodule update --init test/samples' first."

  meta = {
    description = "DTS Coherent Acoustics decoder with support for HD extensions";
    mainProgram = "dcadec";
    homepage = "https://github.com/foo86/dcadec";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
  };
})
