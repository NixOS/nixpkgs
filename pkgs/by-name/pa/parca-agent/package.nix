{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "parca-agent";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-agent";
    rev = "refs/tags/v${version}";
    hash = "sha256-5MoHX47uUtQgszNuu9ImLJPYnaN2NKZKOPa60PMHDL0=";
    fetchSubmodules = true;
  };

  proxyVendor = true;
  vendorHash = "sha256-v2OnCuOI9inZ4WiU/3PbBwK6ZcvZX21MNsLhRWZ6sGY=";

  buildInputs = [
    stdenv.cc.libc.static
  ];

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-extldflags=-static"
  ];

  tags = [
    "osusergo"
    "netgo"
  ];

  meta = {
    description = "eBPF based, always-on profiling agent";
    homepage = "https://github.com/parca-dev/parca-agent";
    changelog = "https://github.com/parca-dev/parca-agent/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
    mainProgram = "parca-agent";
  };
}
