{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, nvidia-container-runtime
}:
buildGoModule rec {
  pname = "nvidia-container-toolkit";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    sha256 = "04284bhgx4j55vg9ifvbji2bvmfjfy3h1lq7q356ffgw3yr9n0hn";
  };

  vendorSha256 = "17zpiyvf22skfcisflsp6pn56y6a793jcx89kw976fq2x5br1bz7";
  buildFlagsArray = [ "-ldflags=" "-s -w" ];
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
