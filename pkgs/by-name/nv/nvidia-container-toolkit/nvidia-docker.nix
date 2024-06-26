{
  stdenv,
  lib,
  fetchFromGitHub,
  callPackage,
}:
stdenv.mkDerivation rec {
  pname = "nvidia-docker";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n1k7fnimky67s12p2ycaq9mgk245fchq62vgd7bl3bzfcbg0z4h";
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
