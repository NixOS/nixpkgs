{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-nomad";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "rraval";
    repo = "git-nomad";
    rev = "v${version}";
    sha256 = "sha256-0svIieFrWIXH25q9dNDzlywYrSe0syhb0qpkDbRAfd4=";
  };

  cargoHash = "sha256-zmjHD7EBXTppfB40UOT/SvKIqQj+vb7Sriasu1twTrg=";

  nativeCheckInputs = [ git ];

  meta = {
    description = "Synchronize work-in-progress git branches in a light weight fashion";
    homepage = "https://github.com/rraval/git-nomad";
    changelog = "https://github.com/rraval/git-nomad/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rraval ];
    mainProgram = "git-nomad";
  };
}
