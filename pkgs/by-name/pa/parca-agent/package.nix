{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  nix-update-script,
}:

buildGoModule rec {
  pname = "parca-agent";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-agent";
    tag = "v${version}";
    hash = "sha256-Ss6ZWoEUSNM5m3BUwLcIuhFbfMHHDdfSjxvnGzNPYM4=";
    fetchSubmodules = true;
  };

  proxyVendor = true;
  vendorHash = "sha256-+yCa5t6bBKOnUjoAQ1QqbK9xLwhNj5vyFeJD71AsNcI=";

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

  passthru.updateScript = nix-update-script { };

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
