{
  copyDesktopItems,
  darwin,
  electron,
  fetchFromGitHub,
  git,
  imagemagick,
  lib,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
  nodejs,
  pnpm_9,
  python3,
  stdenv,
}:

let
  targetSpecificBuildArgs =
    {
      "aarch64-darwin" = "--mac --arm64";
      "x86_64-darwin" = "--mac --x64";
      "x86_64-linux" = "--linux --x64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "arch not supported");

  runtimePath = lib.makeBinPath [ git ];
in

stdenv.mkDerivation (finalAttrs: rec {
  pname = "relagit";
  version = "0.16.9";

  src = fetchFromGitHub {
    owner = "relagit";
    repo = "relagit";
    rev = "v${version}";
    hash = "sha256-uVDQN/wOBf0WJtGW6as28K2saKla7Be/jPOCefKDcdk=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  nativeBuildInputs =
    [
      git
      nodejs
      pnpm_9.configHook
      python3
      makeWrapper
      imagemagick
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.autoSignDarwinBinariesHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
    ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-jTlXN7PFbqNo5EAMgspxGzJwbTMry9mKT5GOgXKIFxM=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = true;
  };

  preBuild = ''
    substituteInPlace ./electron.vite.config.ts \
        --replace-fail \
            "'git rev-parse HEAD'" \
            "'cat COMMIT'"

    substituteInPlace ./builder.cjs \
        --replace-fail \
            "codesign --force --deep -s - ./out/mac-arm64/RelaGit.app" \
            ":" \
        --replace-fail \
            "codesign --force --deep -s - ./out/mac/RelaGit.app" \
            ":"
  '';

  buildPhase = ''
    runHook preBuild

    # electronDist needs to be modifiable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pnpm --offline electron-vite build
    pnpm --offline electron-builder \
      --dir \
      ${targetSpecificBuildArgs} \
      --config builder.cjs \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -r out/mac*/RelaGit.app $out/Applications
          wrapProgram $out/Applications/RelaGit.app/Contents/MacOS/RelaGit \
              --prefix PATH : ${runtimePath}
        ''
      else
        ''
          mkdir -p $out/share/relagit
          cp -r out/linux-unpacked/{locales,resources{,.pak}} $out/share/relagit

          mkdir -p $out/share/icons/hicolor/256x256/apps
          magick convert build/icon.png -resize 256x256 $out/share/icons/hicolor/256x256/apps/relagit.png

          makeWrapper ${lib.getExe electron} $out/bin/relagit \
              --chdir $out/share/relagit/resources \
              --add-flags $out/share/relagit/resources/app \
              --set ELECTRON_FORCE_IS_PACKAGED 1 \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
              --prefix PATH : ${runtimePath} \
              --inherit-argv0
        ''
    }

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "relagit";
      exec = "relagit";
      icon = "relagit";
      desktopName = "RelaGit";
      comment = meta.description;
      categories = [
        "Development"
        "RevisionControl"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The elegant solution to graphical version control";
    homepage = "https://rela.dev/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ mschuwalow ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
