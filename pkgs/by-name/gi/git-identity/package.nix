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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "madx";
    repo = "git-identity";
    tag = "v${version}";
    hash = "sha256-Wz3+rRi6k7cNXPPBE8L39UOABxaL+E8nNSAeKNMOQMM=";
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
