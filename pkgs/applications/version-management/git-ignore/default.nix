{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "git-ignore";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "sondr3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kfc4LIFjLMltCn3BPaEfxc/yOZxFjYioyobTQZN/RmY=";
  };

  cargoHash = "sha256-HoW10XzWIjxsqoKVKQkMf5in7pOODGnUM0cRZP1OJpg=";

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
