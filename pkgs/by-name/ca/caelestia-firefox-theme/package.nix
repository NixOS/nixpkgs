{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  unstableGitUpdater,
  coreutils,
  fish,
  jq,
  inotify-tools,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "caelestia-firefox-theme";
  version = "0-unstable-2026-10-07";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "caelestia-dots";
    repo = "caelestia";
    rev = "248ce84f8b1951c1e93e9e1d37b572901d3a6895";
    hash = "sha256-kzHvG6fNVgCNpViuzC3tBbEeuFTNwsVd9XUzj/Oty2s=";
  };

  sourceRoot = "${finalAttrs.src.name}/firefox/native_app";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ fish ];

  # Nix has no `/usr`. Point the manifest at this package's own copy.
  postPatch = ''
    substituteInPlace manifest.json \
      --replace-fail /usr/lib/caelestia/caelestiafox $out/lib/caelestia/caelestiafox
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 manifest.json $out/lib/mozilla/native-messaging-hosts/caelestiafox.json
    install -Dm755 app.fish $out/lib/caelestia/caelestiafox

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/lib/caelestia/caelestiafox \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          jq
          inotify-tools
        ]
      }"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Native app component of the CaelestiaFox Firefox theme";
    longDescription = ''
      This is the native app component of the CaelestiaFox Firefox extension.
      For the extension to work properly, please install the Firefox extension
      itself from the url below:
      https://addons.mozilla.org/en-US/firefox/addon/caelestiafox
    '';
    homepage = "https://github.com/caelestia-dots/caelestia";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ _1Git2Clone ];
    platforms = lib.platforms.linux;
  };
})
