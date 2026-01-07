{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "hdapsd";
  version = "20250908";

  src = fetchurl {
    url = "https://github.com/evgeni/hdapsd/releases/download/${version}/hdapsd-${version}.tar.gz";
    sha256 = "sha256-qENcOFJ9x5CkN72ZkTx/OL+gpwAYJlJomKvAjTklDYQ=";
  };

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];

  doInstallCheck = true;

  postInstall = builtins.readFile ./postInstall.sh;

  meta = {
    description = "Hard Drive Active Protection System Daemon";
    mainProgram = "hdapsd";
    homepage = "http://hdaps.sf.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
