{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cli-tips";
  version = "0-unstable-2024-12-26";

  src = fetchFromGitHub {
    owner = "cli-stuff";
    repo = "cli-tips";
    rev = "ddb654baa8ffda13e325e2d48f1089c64025153a";
    hash = "sha256-eRQcYoqDxhsfbOdWGcYABQMcwjwmYQXfAUzTKeKPW8I=";
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
