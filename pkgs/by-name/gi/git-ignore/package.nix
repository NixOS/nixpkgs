{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "git-ignore";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "sondr3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KIdhsbD9v2kCM2C/kSJCleyniEz4Bw7UxBsF762fnJs=";
  };

  cargoHash = "sha256-UicChl0wD2GSCCHAqF4/FKVq15g9qusNOnNJJW2B/nw=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
