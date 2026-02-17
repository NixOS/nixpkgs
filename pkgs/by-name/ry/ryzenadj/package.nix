{
  lib,
  stdenv,
  fetchFromGitHub,
  pciutils,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ryzenadj";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "FlyGoat";
    repo = "RyzenAdj";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-28ld8htm3DewTSV3WTG4dFOcX4JAEUMK9rq4AAm1/zY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    pciutils
  ];

  strictDeps = true;

  installPhase = ''
    install -D libryzenadj.so $out/lib/libryzenadj.so
    install -D ryzenadj $out/bin/ryzenadj
  '';

  meta = {
    description = "Adjust power management settings for Ryzen Mobile Processors";
    mainProgram = "ryzenadj";
    homepage = "https://github.com/FlyGoat/RyzenAdj";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ rhendric ];
    platforms = [ "x86_64-linux" ];
  };
})
