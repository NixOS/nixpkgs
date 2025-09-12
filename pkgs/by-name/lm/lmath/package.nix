{
  lib,
  nix-update-script,
  fetchurl,
  appimageTools,
  makeBinaryWrapper,
}:
let
  pname = "lmath";
  version = "1.10.15";
  src = fetchurl {
    url = "https://github.com/lehtoroni/lmath-issues/releases/download/v${version}/LMath_Linux_r${version}-release.AppImage";
    hash = "sha256-JOV+g7izjctCkHl5q/9T2PSUZzPzVPisHppbPofVYy0=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  # '--skip-updated-bundle-check' stops automatic updates from breaking the package
  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/lmath.desktop $out/share/applications/lmath.desktop
    install -Dm 444 ${appimageContents}/lmath.png $out/share/icons/hicolor/512x512/apps/lmath.png

    wrapProgram $out/bin/lmath \
      --add-flags "--no-update-check"

    substituteInPlace $out/share/applications/lmath.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=lmath'
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^r([0-9\.]*)"
    ];
  };

  meta = {
    description = "Simple notebook app with LaTeX capabilities";
    homepage = "https://lehtodigital.fi/lmath/";
    mainProgram = "lmath";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ langsjo ];
    platforms = [ "x86_64-linux" ];
  };
}
