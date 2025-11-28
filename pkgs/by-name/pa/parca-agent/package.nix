{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "parca-agent";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSVeb40KQA/F8tj329Vis4pSVsJL9PlA69iA+RJwdt8=";
    fetchSubmodules = true;
  };

  proxyVendor = true;
  vendorHash = "sha256-98Ndx9eIVIJA9Zox/9fQ80MZwVjuAtInRWbFncQRz/4=";

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
