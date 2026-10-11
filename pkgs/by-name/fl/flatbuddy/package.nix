{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  yq-go,
  jq,
  flatpak,
  flatpak-builder,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatbuddy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tulilirockz";
    repo = "flatbuddy";
    rev = "297d2c22574c200c987eef1b0ab33933fd1bfe8b";
    hash = "sha256-bbmCUplmonDy7G5FrTmy7rFDiA1hUwkXOufqxDhKlKg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 flatbuddy        $out/bin/flatbuddy
    install -Dm755 flatbuddy-build   $out/bin/flatbuddy-build
    install -Dm755 flatbuddy-exec    $out/bin/flatbuddy-exec
    install -Dm755 flatbuddy-inspect $out/bin/flatbuddy-inspect
    install -Dm755 flatbuddy-lint    $out/bin/flatbuddy-lint
    install -Dm755 flatbuddy-track   $out/bin/flatbuddy-track
    ln -s flatbuddy $out/bin/fb

    runHook postInstall
  '';

  postFixup = ''
    for bin in flatbuddy flatbuddy-build flatbuddy-exec flatbuddy-inspect flatbuddy-lint flatbuddy-track; do
      wrapProgram $out/bin/$bin \
        --prefix PATH : ${lib.makeBinPath [ yq-go jq flatpak flatpak-builder ]}
    done
  '';

  meta = {
    description = "Flatpak development swiss army knife";
    longDescription = ''Flatpak development swiss army knife: Build, develop, update and debug flatpak applications easier.'';
    homepage = "https://github.com/tulilirockz/flatbuddy";
    changelog = "https://github.com/tulilirockz/flatbuddy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nothingneko ];
    mainProgram = "flatbuddy";
    platforms = lib.platforms.linux;
  };
})
