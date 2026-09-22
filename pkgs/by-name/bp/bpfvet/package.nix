{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bpfvet";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "boratanrikulu";
    repo = "bpfvet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-++vCltHBmy0JPzNjZ7qe1I9eValBcw2V+j9WRZKVAG8=";
  };

  vendorHash = "sha256-hnkmkHUS5QzhnlDXB6CF683aDBTnJC86J4//IBcJLOA=";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "BPF portability analyzer for compiled eBPF object files";
    homepage = "https://github.com/boratanrikulu/bpfvet";
    changelog = "https://github.com/boratanrikulu/bpfvet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "bpfvet";
  };
})
