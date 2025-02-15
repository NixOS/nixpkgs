{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-nomad";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rraval";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G/i+mCKZSe8tPMuCLzymkU9SGyFNHY74cGhcC4ru0/k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WfmHQ9HXEGfAKQXPMJFNeuOYA0NbmwWdntZjP/YHWCw=";

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "Synchronize work-in-progress git branches in a light weight fashion";
    homepage = "https://github.com/rraval/git-nomad";
    changelog = "https://github.com/rraval/git-nomad/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ rraval ];
    mainProgram = "git-nomad";
  };
}
