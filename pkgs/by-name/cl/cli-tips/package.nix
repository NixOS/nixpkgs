{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cli-tips";
  version = "0-unstable-2024-11-14";

  src = fetchFromGitHub {
    owner = "cli-stuff";
    repo = "cli-tips";
    rev = "ebc191a54be7e39accd1948c3de8aded438d0495";
    hash = "sha256-KELgatdL+2M5ktuAHEljIEJ9wqP578dp5tYWYPpP3bg=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool that provides useful tips and commands for Linux users";
    homepage = "https://github.com/cli-stuff/cli-tips";
    license = lib.licenses.unlicense;
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ perchun ];
    mainProgram = "cli-tips";
  };
}
