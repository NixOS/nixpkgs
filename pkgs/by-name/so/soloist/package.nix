{
  autoPatchelfHook,
  fetchurl,
  lib,
  libpulseaudio,
  makeWrapper,
  pipewire,
  stdenv,
  versionCheckHook,
}:

let
  # Spotify serves every build under stable (unversioned) archive URLs and
  # deletes builds 90 days after their build date, so pin immutable Wayback
  # Machine snapshots; update.sh mints fresh ones on update.
  sources = {
    x86_64-linux = fetchurl {
      url = "https://web.archive.org/web/20261121183347id_/https://soloist-builds.spotifycdn.com/soloist_release_x86_64.tar.gz";
      hash = "sha256-0ATDNo17sGtD9z+ArkuAgm2wiqA7IStY+3+q75rUUaE=";
    };
    aarch64-linux = fetchurl {
      url = "https://web.archive.org/web/20261121183441id_/https://soloist-builds.spotifycdn.com/soloist_release_arm64.tar.gz";
      hash = "sha256-ty44hA0CPgdBggqgmIPdAq3SxrCpFuOb/L/VceQ+evg=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "soloist";
  version = "1.4.0";

  strictDeps = true;
  __structuredAttrs = true;

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 soloist $out/bin/soloist
    install -Dm644 CHANGELOG.md $out/share/doc/soloist/CHANGELOG.md
    install -Dm644 THIRD_PARTY_LICENSES.txt $out/share/licenses/soloist/THIRD_PARTY_LICENSES.txt

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/soloist \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          pipewire
          libpulseaudio
        ]
      }"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Headless Spotify Connect client for Linux";
    homepage = "https://developer.spotify.com/documentation/soloist";
    downloadPage = "https://developer.spotify.com/documentation/soloist/reference/downloads-and-updates";
    license = lib.licenses.unfree;
    mainProgram = "soloist";
    maintainers = with lib.maintainers; [ tlvince ];
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
