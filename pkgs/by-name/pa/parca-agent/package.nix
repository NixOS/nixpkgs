{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "parca-agent";
<<<<<<< HEAD
  version = "0.44.2";
=======
  version = "0.44.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca-agent";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-nRStraxWDk3eY6L4znPsvT+NNz/cIYBae5sdYnOybi0=";
=======
    hash = "sha256-RSVeb40KQA/F8tj329Vis4pSVsJL9PlA69iA+RJwdt8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  proxyVendor = true;
<<<<<<< HEAD
  vendorHash = "sha256-OvhKmCxLIzLXxBmTaLrZFTAIkZXG2C1AZggaVYhlF3I=";
=======
  vendorHash = "sha256-98Ndx9eIVIJA9Zox/9fQ80MZwVjuAtInRWbFncQRz/4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
