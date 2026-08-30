{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cli-tips";
  version = "0-unstable-2026-03-29";

  src = fetchFromGitHub {
    owner = "cli-stuff";
    repo = "cli-tips";
    rev = "0268e0e3a8eddf21a61a4d21be3b5b81629b14b4";
    hash = "sha256-Pjb3p2EIM+7fz83t9QTjSeFoxbvDYWTYoxtJ0MAMB2s=";
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
    maintainers = with lib.maintainers; [ PerchunPak ];
    mainProgram = "cli-tips";
  };
}
