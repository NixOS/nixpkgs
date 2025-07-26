{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cli-tips";
  version = "0-unstable-2025-06-13";

  src = fetchFromGitHub {
    owner = "cli-stuff";
    repo = "cli-tips";
    rev = "be62dcd3fef8a32166775d90c5538a18bf7fed94";
    hash = "sha256-irl9TXk+8ME8dXQmsYR13uIlqFyZyUgREXROxeX65VY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/tips
    install -Dm755 cli-tips.sh $out/bin/cli-tips
    cp tips.txt $out/share/tips

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/cli-tips \
      --set TIPS_FOLDER "$out/share/tips"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "CLI tool that provides useful tips and commands for Linux users";
    homepage = "https://github.com/cli-stuff/cli-tips";
    license = lib.licenses.unlicense;
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ perchun ];
    mainProgram = "cli-tips";
  };
}
