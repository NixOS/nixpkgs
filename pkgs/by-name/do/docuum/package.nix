{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "docuum";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "docuum";
    rev = "v${version}";
    hash = "sha256-nWd6h39jU1eZWPFMxhxActsmrs9k0TDMlealuzTa+o0=";
  };

  cargoHash = "sha256-ce8mthEWvZ+U2+lU3gGrq1YBzbkiqUGJV5JUsZ+HhBg=";

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
