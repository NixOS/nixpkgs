{
  lib,
  fetchFromGitHub,
  makeWrapper,
  electron,
  python3,
  stdenv,
  stdenvNoCC,
  copyDesktopItems,
  moreutils,
  cacert,
  jq,
  nodePackages,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "youtube-music";
  version = "3.3.6";

  src = fetchFromGitHub {
    owner = "th-ch";
    repo = "youtube-music";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nxpctEG4XoxW6jOAxGdgTEYr6YnhFRR8+5HUQLxRJB0=";
  };

  pnpmDeps = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-pnpm-deps";
    inherit (finalAttrs) src version ELECTRON_SKIP_BINARY_DOWNLOAD;

    nativeBuildInputs = [
      jq
      moreutils
      nodePackages.pnpm
      cacert
    ];

    installPhase = ''
      export HOME=$(mktemp -d)

      pnpm config set store-dir $out
      pnpm install --frozen-lockfile --ignore-script

      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    dontBuild = true;
    dontFixup = true;
    outputHashMode = "recursive";
    outputHash =
      {
        x86_64-linux = "sha256-bujlQxP6Lr3qPUDxYXKyb702ZJY/xbuCsu3wVDhcb+8=";
        aarch64-linux = "sha256-0kyjjttpXpFVhdza5NAjGrRn++qc/N5/u2dQl7VufLE=";
        x86_64-darwin = "sha256-Q37QJt/mhfpSguOlkJGKFTCrIOrpbG3OBwaD/Bg09Us=";
        aarch64-darwin = "sha256-wbfjzoGa/6vIlOOVX3bKNQ2uxzph3WSofo3MGXqA6yQ=";
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  };

  nativeBuildInputs = [
    makeWrapper
    python3
    nodePackages.pnpm
    nodePackages.nodejs
  ] ++ lib.optionals (!stdenv.isDarwin) [ copyDesktopItems ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  preBuild = ''
    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    cp -Tr "$pnpmDeps" "$STORE_PATH"
    chmod -R +w "$STORE_PATH"

    pnpm config set store-dir "$STORE_PATH"
    pnpm install --offline --frozen-lockfile --ignore-script
    patchShebangs node_modules/{*,.*}
  '';

  postBuild =
    lib.optionalString stdenv.isDarwin ''
      cp -R ${electron}/Applications/Electron.app Electron.app
      chmod -R u+w Electron.app
    ''
    + ''
      pnpm build
      ./node_modules/.bin/electron-builder \
        --dir \
        -c.electronDist=${if stdenv.isDarwin then "." else "${electron}/libexec/electron"} \
        -c.electronVersion=${electron.version}
    '';

  installPhase =
    ''
      runHook preInstall

    ''
    + lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/{Applications,bin}
      mv pack/mac*/YouTube\ Music.app $out/Applications
      makeWrapper $out/Applications/YouTube\ Music.app/Contents/MacOS/YouTube\ Music $out/bin/youtube-music
    ''
    + lib.optionalString (!stdenv.isDarwin) ''
      mkdir -p "$out/share/lib/youtube-music"
      cp -r pack/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/youtube-music"

      pushd assets/generated/icons/png
      for file in *.png; do
        install -Dm0644 $file $out/share/icons/hicolor/''${file//.png}/apps/youtube-music.png
      done
      popd
    ''
    + ''

      runHook postInstall
    '';

  postFixup = lib.optionalString (!stdenv.isDarwin) ''
    makeWrapper ${electron}/bin/electron $out/bin/youtube-music \
      --add-flags $out/share/lib/youtube-music/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "youtube-music";
      exec = "youtube-music %u";
      icon = "youtube-music";
      desktopName = "Youtube Music";
      startupWMClass = "Youtube Music";
      categories = [ "AudioVideo" ];
    })
  ];

  meta = with lib; {
    description = "Electron wrapper around YouTube Music";
    homepage = "https://th-ch.github.io/youtube-music/";
    license = licenses.mit;
    maintainers = [ maintainers.aacebedo ];
    mainProgram = "youtube-music";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
