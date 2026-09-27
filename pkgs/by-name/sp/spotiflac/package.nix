{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_10,
  ffmpeg-headless,
  wails,
  glib-networking,
  gsettings-desktop-schemas,
  gtk3,
  pnpmConfigHook,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  wrapGAppsHook3,
}:

buildGoModule (finalAttrs: {
  pname = "spotiflac";
  version = "7.2.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "spotbye";
    repo = "SpotiFLAC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bi8V//3xd2ScVaPDARjZgm4TC2vmDNr0bnfPBdk+MZo=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    pnpmConfigHook
    pnpm_10
    wails
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking
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
      hash = "sha256-/E8YZGW4lnOMJGnNwp3Peua/TuWoGy6lij87SLl1jCA=";
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

    wails build -tags webkit2_41 -devtools -o spotiflac

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall;

    install -Dm 0755 build/bin/spotiflac $out/bin/spotiflac

    # See https://wails.io/docs/guides/nixos-font
    wrapProgram $out/bin/spotiflac \
      --set GIO_EXTRA_MODULES ${glib-networking}/lib/gio/modules \
      --set XDG_DATA_DIRS ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name} \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}

    install -D frontend/src/assets/icons/spotiflac.svg $out/share/icons/hicolor/scalable/apps/SpotiFLAC.svg

    runHook postInstall;
  '';

  vendorHash = "sha256-B8FgP4w08imhrERyAbmLjvBIyb+5I05hhY2rF+uJoV4=";

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
    homepage = "https://github.com/spotbye/SpotiFLAC/";
    changelog = "https://github.com/spotbye/SpotiFLAC/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "spotiflac";
    maintainers = with lib.maintainers; [
      Superredstone
    ];
  };
})
