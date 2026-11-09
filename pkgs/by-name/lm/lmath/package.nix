{
  lib,
  nix-update-script,
  fetchurl,
  appimageTools,
  makeBinaryWrapper,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "lmath";
  version = "1.11.2";
  src = fetchurl {
    url = "https://github.com/lehtoroni/lmath-issues/releases/download/v${finalAttrs.version}/LMath_Linux_r${finalAttrs.version}-release.AppImage";
    hash = "sha256-NHfNnBYxKXRk4IQonQTjYtIIk3apZs45BbWGIvLfl3w=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  # '--skip-updated-bundle-check' stops automatic updates from breaking the package
  extraInstallCommands = ''
    install -Dm 444 ${finalAttrs.contents}/lmath.desktop $out/share/applications/lmath.desktop
    install -Dm 444 ${finalAttrs.contents}/lmath.png $out/share/icons/hicolor/512x512/apps/lmath.png

    wrapProgram $out/bin/lmath \
      --add-flags "--no-update-check"

    substituteInPlace $out/share/applications/lmath.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=lmath'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple notebook app with LaTeX capabilities";
    homepage = "https://lehtodigital.fi/lmath/";
    mainProgram = "lmath";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ langsjo ];
    platforms = [ "x86_64-linux" ];
  };
})
