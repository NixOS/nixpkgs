{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, nvidia-container-runtime
}:
buildGoModule rec {
  pname = "nvidia-container-toolkit";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YvwqnwYOrlSE6PmNNZ5xjEaEcXdHKcakIwua+tOvIJ0=";
  };

  vendorSha256 = "17zpiyvf22skfcisflsp6pn56y6a793jcx89kw976fq2x5br1bz7";
  ldflags = [ "-s" "-w" ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv $out/bin/{pkg,${pname}}
    ln -s $out/bin/nvidia-container-{toolkit,runtime-hook}

    wrapProgram $out/bin/nvidia-container-toolkit \
      --add-flags "-config ${nvidia-container-runtime}/etc/nvidia-container-runtime/config.toml"
  '';

  meta = with lib; {
    homepage = "https://github.com/NVIDIA/nvidia-container-toolkit";
    description = "NVIDIA container runtime hook";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cpcloud ];
  };
}
