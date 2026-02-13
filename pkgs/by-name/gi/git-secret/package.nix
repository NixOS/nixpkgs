{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  git,
  gnupg,
  gawk,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "git-secret";
  version = "0.5.0-unstable-2024-12-09";

  src = fetchFromGitHub {
    repo = "git-secret";
    owner = "sobolevn";
    rev = "fdc5e755b34569b0ad3d84a85e611afbb86c4db5";
    hash = "sha256-SN6Xpkc8bd1yuvUMlKaXb5M1ts1JxZynVa5GHBKyOjw=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase =
    let
      binPath = lib.makeBinPath [
        git
        gnupg
        gawk
      ];
    in
    ''
      runHook preInstall

      installBin git-secret
      wrapProgram "$out/bin/git-secret" --prefix PATH : "${binPath}"

      shopt -s extglob
      installManPage man/**/!(*.md)
      shopt -u extglob

      runHook postInstall
    '';

  meta = {
    description = "Bash-tool to store your private data inside a git repository";
    homepage = "https://sobolevn.me/git-secret/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lo1tuma ];
    platforms = lib.platforms.all;
    mainProgram = "git-secret";
  };
}
