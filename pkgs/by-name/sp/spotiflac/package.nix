{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_10,
  ffmpeg_7-headless,
  wails,
  pnpmConfigHook,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  wrapGAppsHook3,
}:

buildGo126Module (finalAttrs: {
  pname = "spotiflac";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "afkarxyz";
    repo = "SpotiFLAC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qpa2M/MEzR+nQiLAeI+mTaaLQVVQA236ChNZMqXksk8=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    pnpmConfigHook
    pnpm_10
    wails
    makeWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  proxyVendor = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  env = {
    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/frontend";
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-QASHE0duz2ziNcjoswgujmaXIB9yiY9B5VPF7oFLQiU=";
    };
    pnpmRoot = "frontend";
  };

  overrideModAttrs = {
    preBuild = ''
      wails build -tags webkit2_41 -o spotiflac
    '';
  };

  buildPhase = ''
    runHook preBuild

    wails build -tags webkit2_41 -o spotiflac

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall;

    install -Dm 0755 build/bin/spotiflac $out/bin/spotiflac

    wrapProgram $out/bin/spotiflac \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg_7-headless ]}

    runHook postInstall;
  '';

  vendorHash = "sha256-qr8BGu+tJWtR3Uw+incPcA3T7L7wss3JKJ3FwknZ/oI=";

  desktopItems = [
    (makeDesktopItem {
      name = "spotiflac";
      desktopName = "SpotiFLAC";
      exec = "spotiflac %u";
      icon = "SpotiFLAC";
      terminal = false;
      categories = [ "AudioVideo" ];
    })
  ];

  meta = {
    description = "Get Spotify tracks in true FLAC from Tidal, Qobuz & Amazon Music — no account required";
    homepage = "https://github.com/afkarxyz/SpotiFLAC/";
    changelog = "https://github.com/afkarxyz/SpotiFLAC/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "spotiflac";
    maintainers = with lib.maintainers; [
      Superredstone
    ];
  };
})
