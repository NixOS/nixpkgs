{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "parca-agent";
  version = "0.35.2";

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-agent";
    tag = "v${version}";
    hash = "sha256-g+lUwo4Ng+Z103xya8CmGEoZ+vYVSpQu0CAaqafcinU=";
    fetchSubmodules = true;
  };

  proxyVendor = true;
  vendorHash = "sha256-0XeotSwudDdDaQ/d+htvDK3ajBK8FRElbssz7dy3XsI=";

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
