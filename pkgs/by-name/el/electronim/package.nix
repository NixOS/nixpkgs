{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  moreutils,
  makeWrapper,
  electron,
}:

buildNpmPackage rec {
  pname = "electronim";
  version = "0.0.102";

  src = fetchFromGitHub {
    owner = "manusa";
    repo = "electronim";
    rev = "refs/tags/v${version}";
    hash = "sha256-yx/5pdyy0JqtC2YPhgXstd+U+K7lwcX04Z+ZIs3lbLs=";
  };

  postPatch = ''
    # move "electron" from "dependencies" to "devDependencies"
    ${jq}/bin/jq ".devDependencies.electron = .dependencies.electron | del(.dependencies.electron)" package.json | ${moreutils}/bin/sponge package.json
  '';

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [ makeWrapper ];

  npmDepsHash = "sha256-cWlD0BuBEXIh33cbsVn0KBuzuDxMurxqj4wvGT8dtSE=";

  buildPhase = ''
    runHook preBuild

    npm run prepack
    npm exec electron-builder -- \
        --dir \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/electronim
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/electronim

    makeWrapper ${electron}/bin/electron $out/bin/electronim \
        --add-flags $out/share/electronim/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --inherit-argv0

    install -Dm644 src/assets/icon_1024x1024.png $out/share/icons/hicolor/1024x1024/apps/electronim.png
    install -Dm644 build-config/electronim.desktop $out/share/applications/electronim.desktop

    substituteInPlace $out/share/applications/electronim.desktop \
        --replace-fail '/opt/electronim/electronim' 'electronim' \
        --replace-fail '/opt/electronim/assets/icon_1024x1024.png' 'electronim'

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/manusa/electronim/releases/tag/v${version}";
    description = "Free/Libre Electron based multi instant messaging (IM) client";
    homepage = "https://github.com/manusa/electronim";
    license = lib.licenses.asl20;
    mainProgram = "electronim";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = electron.meta.platforms;
  };
}
