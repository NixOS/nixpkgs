{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "parca-agent";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NcvEU9MgAYK7jFbg/jdUP/ltgzDAIR6JNphv5Xkcba4=";
    fetchSubmodules = true;
  };

  proxyVendor = true;
  vendorHash = "sha256-/V4proGF8Vpv2w4+3vZv4tcKkEgBi6eZGMjXW9vrLts=";

  buildInputs = [
    stdenv.cc.libc.static
  ];

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
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
    changelog = "https://github.com/parca-dev/parca-agent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      brancz
      metalmatze
    ];
    platforms = lib.platforms.linux;
    mainProgram = "parca-agent";
  };
})
