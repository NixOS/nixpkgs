{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, callPackage
, makeWrapper
, buildGoModule
, buildGoPackage
, glibc
, docker
, linkFarm
}:

with lib; let
in
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
    mkdir -p $out/{bin,etc}
    cp -r bin $out

    cp ${./config.toml} $out/etc/config.toml
    substituteInPlace $out/etc/config.toml --subst-var-by glibcbin ${lib.getBin glibc}

    cp ${./podman-config.toml} $out/etc/podman-config.toml
    substituteInPlace $out/etc/podman-config.toml --subst-var-by glibcbin ${lib.getBin glibc}
  '';

  meta = {
    homepage = "https://github.com/NVIDIA/nvidia-docker";
    description = "NVIDIA container runtime for Docker";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
