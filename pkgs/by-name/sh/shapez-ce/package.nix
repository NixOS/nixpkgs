{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  jdk,
  fetchurl,
  makeWrapper,
  pngquant,
  optipng,
  gifsicle,
  mozjpeg,
  ffmpeg,
  electron,
  zip,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:
let
  stdenv = stdenvNoCC;

  # Building it reproducibly is a PITA and the upstream only publishes nightlies so we use
  # web archive as a workaround
  texturePackerJar = fetchurl {
    url = "https://web.archive.org/web/20241202185338if_/https://libgdx-nightlies.s3.amazonaws.com/libgdx-runnables/runnable-texturepacker.jar";
    hash = "sha256-M0fvcxIzdMrHq87+dd3N99fvGJARYD7EUth/Gli2q80=";
  };

  pname = "shapez-ce";
  version = "0-unstable-2025-08-25";
  src = fetchFromGitHub {
    owner = "tobspr-games";
    repo = "shapez-community-edition";
    rev = "b2e494ca482da9b112dfaf5c3c8ece67b76f55c8";
    hash = "sha256-LAhiHs0ljpc+6qxuD/k52smasf3y5EgizqmMaPQvAV8=";
  };

  electronDeps = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-electron-deps";
    inherit version;
    src = src + "/electron";

    env = {
      ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    };

    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-npm-deps";
      inherit (finalAttrs) version src;
      hash = "sha256-jlYKm6QS2QPV+wYYYLxRlcL06eKrTDZoa53EET3ZtLg=";
    };

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
    ];

    installPhase = ''
      cp -r node_modules $out
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) version src;
    hash = "sha256-GVeOatGtyKkeRunKrse4c+00UGJlRJWxvVlplpZ47H0=";
  };

  postPatch =
    let
      linkBinDeps = lib.concatStringsSep "&&" [
        "ln -s ${lib.getExe pngquant} node_modules/pngquant-bin/vendor/pngquant"
        "ln -s ${lib.getExe optipng} node_modules/optipng-bin/vendor/optipng"
        "ln -s ${lib.getExe' gifsicle "gifsicle"} node_modules/gifsicle/vendor/gifsicle"
        "ln -s ${lib.getExe' mozjpeg "jpegtran"} node_modules/jpegtran-bin/vendor/jpegtran"
      ];
    in
    ''
      substituteInPlace package.json \
        --replace-fail '"postinstall"' \
        '"install": "${linkBinDeps}", "postinstall"'

      substituteInPlace gulp/environment.js \
        --replace-fail "await fetch(texturePackerUrl);" \
        '{ok: true, body: await fs.readFile("${texturePackerJar}")};';

      substituteInPlace gulp/buildutils.js \
        --replace-fail 'execSync("git rev-parse --short " + (useLast ? "HEAD^1" : "HEAD")).toString("ascii")' \
        '"${lib.strings.substring 0 7 finalAttrs.src.rev}"';
    '';

  strictDeps = true;
  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    jdk
    pngquant
    optipng
    gifsicle
    ffmpeg
    zip
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [ electron ];

  configurePhase = ''
    runHook preConfigure

    cp -r ${electronDeps} electron/node_modules
    chmod -R u+w electron/node_modules

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../gulp/electron.zip .
    popd

    rm -r electron-dist

    # force @electron/packager to use our electron instead of downloading it
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
      --replace-fail 'await this.getElectronZipPath(downloadOpts)' '"electron.zip"'

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # The platform and arch only influence electron download which is replaced by the nixpkgs build
    # so they don't matter
    npm run package-linux-arm64

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/
    cp -r build_output/standalone/shapez-linux-arm64/resources $out/share/shapez-ce

    install -Dm644 electron/favicon.png $out/share/icons/hicolor/512x512/apps/io.shapez.community.png

    makeWrapper '${lib.getExe electron}' "$out/bin/${finalAttrs.meta.mainProgram}" \
      --add-flags "$out/share/shapez-ce/app.asar" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "io.shapez.community";
      desktopName = "shapez CE";
      exec = finalAttrs.meta.mainProgram;
      type = "Application";
      terminal = false;
      icon = "io.shapez.community";
      comment = finalAttrs.meta.description;
      startupWMClass = "shapez-ce";
      categories = [
        "Game"
        "LogicGame"
        "Simulation"
      ];
    })
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Low-stakes factory building game all about the automation of shapes production";
    homepage = "https://shapez.io/";
    license = with lib.licenses; [
      gpl3Plus

      # Various npm packages
      free
    ];
    maintainers = with lib.maintainers; [ marcin-serwin ];
    mainProgram = "shapez-ce";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # texturePackerJar
    ];
  };
})
