{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "nvidia-docker";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-docker";
    rev = "v${version}";
    hash = "sha256-kHzwFnN/DbpOe1sYDJkrRMxXE1bMiyuCPsbPGq07M9g=";
  };

  buildPhase = ''
    mkdir bin

    cp nvidia-docker bin
    substituteInPlace bin/nvidia-docker --subst-var-by VERSION ${version}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/nvidia-docker $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/NVIDIA/nvidia-docker";
    description = "NVIDIA container runtime for Docker";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cpcloud ];
  };
}
