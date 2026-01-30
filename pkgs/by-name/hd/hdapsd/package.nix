{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "hdapsd";
  version = "20250908";

  src = fetchurl {
    url = "https://github.com/linux-thinkpad/hdapsd/releases/download/${version}/hdapsd-${version}.tar.gz";
    hash = "sha256-qENcOFJ9x5CkN72ZkTx/OL+gpwAYJlJomKvAjTklDYQ=";
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
    homepage = "https://github.com/linux-thinkpad/hdapsd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
