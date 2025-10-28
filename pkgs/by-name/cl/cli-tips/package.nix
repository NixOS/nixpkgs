{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cli-tips";
  version = "0-unstable-2025-02-03";

  src = fetchFromGitHub {
    owner = "cli-stuff";
    repo = "cli-tips";
    rev = "34e37224b51362003d1c5af2b0b6bc2a02b668d9";
    hash = "sha256-ZJQGa7gaR76zsdZOVoIf87h2wraFFOuonJEDy6J8ygQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    install -Dm755 cli-tips.sh $out/bin/cli-tips
    cp -r translations $out/share

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/cli-tips \
      --set TIPS_FOLDER "$out/share/translations"
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
