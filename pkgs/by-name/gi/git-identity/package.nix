{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  ronn,
  nix-update-script,
}:
stdenvNoCC.mkDerivation rec {
  pname = "git-identity";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "madx";
    repo = "git-identity";
    rev = "refs/tags/v${version}";
    hash = "sha256-u4lIW0bntaKrVUwodXZ8ZwWxSZtLuhVSUAbIj8jjcLw=";
  };

  nativeBuildInputs = [
    installShellFiles
    ronn
  ];

  buildPhase = ''
    runHook preBuild
    ronn --roff git-identity.1.ronn
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp git-identity $out/bin/git-identity
    installManPage git-identity.1
    installShellCompletion --cmd git-identity \
      --bash git-identity.bash-completion \
      --zsh git-identity.zsh-completion
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage your identity in Git";
    mainProgram = "git-identity";
    homepage = "https://github.com/madx/git-identity";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ mynacol ];
    platforms = lib.platforms.all;
  };
}
