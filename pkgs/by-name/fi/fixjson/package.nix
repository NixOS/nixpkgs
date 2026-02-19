{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "fixjson";
  version = "0-unstable-2023-01-06";

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "fixjson";
    # Upstream has no tagged releases, but this commit bumps version
    rev = "c49f27a0268fca69021fa8aafc9bbef9960f82e9";
    hash = "sha256-Hse2EBppeEBoMQjRI97MNYWlRDpoOMhkZ/nbhpFgH5c=";
  };

  npmDepsHash = "sha256-mreSdJxFjSaz3kNoFC5ZSlBENA2sOLmsxS0VKW4o0z4=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "JSON Fixer for Humans using (relaxed) JSON5";
    homepage = "https://github.com/rhysd/fixjson";
    license = lib.licenses.mit;
    mainProgram = "fixjson";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
