{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-ignore";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "sondr3";
    repo = "git-ignore";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KIdhsbD9v2kCM2C/kSJCleyniEz4Bw7UxBsF762fnJs=";
  };

  cargoHash = "sha256-Zdy6bUgpaDBiAavSlAAH7LyYbNm7UU1qz0wAnVXQzpY=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    assets=$releaseDir/../assets
    installManPage $assets/git-ignore.1
    installShellCompletion $assets/git-ignore.{bash,fish} --zsh $assets/_git-ignore
  '';

  meta = {
    description = "Quickly and easily fetch .gitignore templates from gitignore.io";
    homepage = "https://github.com/sondr3/git-ignore";
    changelog = "https://github.com/sondr3/git-ignore/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "git-ignore";
  };
})
