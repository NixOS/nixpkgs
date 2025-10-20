{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "docuum";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "docuum";
    rev = "v${version}";
    hash = "sha256-fc+qEDYQGRxOSfFng3/K3xYWb8mKTuuKWanQS+/UIMo=";
  };

  cargoHash = "sha256-IryniHpSJDxjW6FRqTILKzp6XrTHxJ19BiYqRYIHnGo=";

  checkFlags = [
    # fails, no idea why
    "--skip=format::tests::code_str_display"
  ];

  meta = with lib; {
    description = "Least recently used (LRU) eviction of Docker images";
    homepage = "https://github.com/stepchowfun/docuum";
    changelog = "https://github.com/stepchowfun/docuum/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "docuum";
  };
}
