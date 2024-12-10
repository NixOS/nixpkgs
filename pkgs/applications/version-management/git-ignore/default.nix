{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-ignore";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "sondr3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OVKRNj3tRi/PGY1m4rdpmH87laYzTkCiwoBc3txVJ3U=";
  };

  cargoHash = "sha256-dAQKL+sMThpTqBoN5MZvm8tQUJhaSH7lT8DwbjzFq40=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    assets=$releaseDir/../assets
    installManPage $assets/git-ignore.1
    installShellCompletion $assets/git-ignore.{bash,fish} --zsh $assets/_git-ignore
  '';

  meta = with lib; {
    description = "Quickly and easily fetch .gitignore templates from gitignore.io";
    homepage = "https://github.com/sondr3/git-ignore";
    changelog = "https://github.com/sondr3/git-ignore/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "git-ignore";
  };
}
