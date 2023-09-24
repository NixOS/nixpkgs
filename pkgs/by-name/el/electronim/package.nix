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
  version = "0.0.100";

  src = fetchFromGitHub {
    owner = "manusa";
    repo = "electronim";
    rev = "v${version}";
    hash = "sha256-1ml9ux2Bj59CQK26J8PFYuPvS4tT5jl3n/SPMbh+cB8=";
  };

  postPatch = ''
    # move "electron" from "dependencies" to "devDependencies"
    ${jq}/bin/jq ".devDependencies.electron = .dependencies.electron | del(.dependencies.electron)" package.json | ${moreutils}/bin/sponge package.json
  '';

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [ makeWrapper ];

  npmDepsHash = "sha256-X84b/PM3b2HsqsE1z3mEVRAUU9ioWQs97VRaU+yXrfQ=";

  buildPhase = ''
    runHook preBuild

    npm run prepack
    npm exec electron-builder -- \
        --dir \
        -c.electronDist=${electron}/libexec/electron \
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
        --replace '/opt/electronim/electronim' 'electronim' \
        --replace '/opt/electronim/assets/icon_1024x1024.png' 'electronim'

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/manusa/electronim/releases/tag/${src.rev}";
    description = "Free/Libre Electron based multi instant messaging (IM) client";
    homepage = "https://github.com/manusa/electronim";
    license = lib.licenses.asl20;
    mainProgram = "electronim";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = electron.meta.platforms;
  };
}
