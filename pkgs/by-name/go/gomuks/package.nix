{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  libnotify,
  olm,
  pulseaudio,
  sound-theme-freedesktop,
  nodejs,
  fetchNpmDeps,
  npmHooks,
  pkg-config,
  libheif,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gomuks";
  version = "26.08";

  src = fetchFromGitHub {
    owner = "gomuks";
    repo = "gomuks";
    tag = "v0.${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}.0";
    hash = "sha256-OgcmRBuVFTPzAVgNVDUZcfdgxHi4mtUcbmfTRPx/f9M=";
  };

  proxyVendor = true;
  vendorHash = "sha256-wNscq9FDJb9+WqKCBZ9YD+EQ/Sc2PAznunKP6hrs+Ms=";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    olm
    libheif
  ];

  env = {
    npmRoot = "web";
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/web";
      hash = "sha256-C+zEMI2wmO3EvefpswTk9Tq3AV1Acfi+w3oO5WpxLIQ=";
    };
  };

  postPatch = ''
    substituteInPlace ./web/build-wasm.sh \
      --replace-fail 'go.mau.fi/gomuks/version.Tag=$(git describe --exact-match --tags 2>/dev/null)' "go.mau.fi/gomuks/version.Tag=${finalAttrs.src.tag}" \
      --replace-fail 'go.mau.fi/gomuks/version.Commit=$(git rev-parse HEAD)' "go.mau.fi/gomuks/version.Commit=unknown"
  '';

  doCheck = false;

  tags = [
    "goolm"
    "libheif"
    "sqlite_fts5"
  ];

  ldflags = [
    "-X 'go.mau.fi/gomuks/version.Tag=${finalAttrs.src.tag}'"
    "-X 'go.mau.fi/gomuks/version.Commit=unknown'"
    "-X \"go.mau.fi/gomuks/version.BuildTime=$(date -Iseconds)\""
    "-X \"maunium.net/go/mautrix.GoModVersion=$(cat go.mod | grep 'maunium.net/go/mautrix ' | head -n1 | awk '{ print $2 })\""
  ];

  subPackages = [
    "cmd/gomuks"
    "cmd/gomuks-terminal"
    "cmd/archivemuks"
  ];

  preBuild = ''
    CGO_ENABLED=0 go generate ./web
  '';

  buildPhase = ''
    runHook preBuild
    ./build-noweb.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./gomuks $out/bin/gomuks
    runHook postInstall
  '';

  postInstall = ''
    cp -r ${
      makeDesktopItem {
        name = "net.maunium.gomuks.desktop";
        exec = "@out@/bin/gomuks";
        terminal = true;
        desktopName = "Gomuks";
        genericName = "Matrix client";
        categories = [
          "Network"
          "Chat"
        ];
        comment = finalAttrs.meta.description;
      }
    }/* $out/
    substituteAllInPlace $out/share/applications/*
    wrapProgram $out/bin/gomuks \
      --prefix PATH : "${
        lib.makeBinPath (
          lib.optionals stdenv.hostPlatform.isLinux [
            libnotify
            pulseaudio
          ]
        )
      }" \
      --set-default GOMUKS_SOUND_NORMAL "${sound-theme-freedesktop}/share/sounds/freedesktop/stereo/message-new-instant.oga" \
      --set-default GOMUKS_SOUND_CRITICAL "${sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga"
  '';

  passthru.updateScript = nix-update-script;
  meta = {
    homepage = "https://maunium.net/go/gomuks/";
    description = "Terminal based Matrix client written in Go";
    mainProgram = "gomuks";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ chvp ];
  };
})
