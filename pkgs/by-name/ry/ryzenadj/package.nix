{
  lib,
  stdenv,
  fetchFromGitHub,
  pciutils,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "ryzenadj";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "FlyGoat";
    repo = "RyzenAdj";
    rev = "v${version}";
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

<<<<<<< HEAD
  meta = {
    description = "Adjust power management settings for Ryzen Mobile Processors";
    mainProgram = "ryzenadj";
    homepage = "https://github.com/FlyGoat/RyzenAdj";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ rhendric ];
=======
  meta = with lib; {
    description = "Adjust power management settings for Ryzen Mobile Processors";
    mainProgram = "ryzenadj";
    homepage = "https://github.com/FlyGoat/RyzenAdj";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ rhendric ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-linux" ];
  };
}
