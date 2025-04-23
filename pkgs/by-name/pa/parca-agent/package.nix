{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "parca-agent";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-agent";
    tag = "v${version}";
    hash = "sha256-GaJeVfpyh61zro/WQgTxPisT/lZPx+BNekpFY6UXcAA=";
    fetchSubmodules = true;
  };

  proxyVendor = true;
  vendorHash = "sha256-5vjG0RAoqE69v8uooRxRD87clkX7dMZCP3W42/2+OSk=";

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
