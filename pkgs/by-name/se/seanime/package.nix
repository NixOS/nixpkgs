{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  ffmpeg,
  fetchNpmDeps,
  nix-update-script,
  stdenv,

  makeDesktopItem,
  copyDesktopItems,
  callPackage,
  # we use the same electron as upstream
  denshi-electron ? callPackage ./electron.nix { },
  mpv-prism ? callPackage ./mpv-prism.nix { },
}:
let
  version = "3.10.2";
  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    tag = "v${version}";
    hash = "sha256-YLpMsvOOqr1wrdE3buqR0DP1GFhMvIkp9+WhpfGTgTk=";
  };

  mpvPrismTarget = if stdenv.hostPlatform.isDarwin then "darwin-arm64" else "linux-x64";

  seanime-web =
    {
      npmBuildScript ? "build",
      installPhase ? ''
        runHook preInstall

        mkdir $out
        cp -r seanime-web/out $out/web

        runHook postInstall
      '',
    }:
    buildNpmPackage {
      pname = "seanime-web";
      inherit
        src
        version
        npmBuildScript
        installPhase
        ;

      patches = [ ./default-disable-update-check.patch ];

      npmBuildFlags = [
        "--prefix"
        "seanime-web"
      ];

      npmRoot = "seanime-web";
      npmDeps = fetchNpmDeps {
        src = "${src}/seanime-web";
        hash = "sha256-ddXxGWSHubOcMppXJTLYnF9ZCYTRhf1ffZM0Wak5O8c=";
      };
    };
in
buildGoModule (finalAttrs: {
  pname = "seanime";
  inherit src version;

  preBuild = ''
    cp -r ${seanime-web { }}/web .

    # .github scripts redeclare main
    rm -rf .github
  '';

  vendorHash = "sha256-eTKLiwyB3bUIUlwLck8NG6oRdYaJioNs4AiSSPjADyg=";

  subPackages = [ "." ];

  doCheck = false; # broken in clean environments

  ldflags = [
    "-s"
    "-w"
  ];

  # for transcoding
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
      ]
    }"
  ];

  passthru.denshi = buildNpmPackage {
    pname = "seanime-denshi";

    inherit src version;

    sourceRoot = "${src.name}/seanime-denshi";

    npmDepsHash = "sha256-CW8dFtAibXa1GNk1pzlDp8zt24Y3o3xfIND2I4cWYLs=";

    nativeBuildInputs = [
      copyDesktopItems
    ];

    patches = [ ./fix-paths.patch ];

    postPatch = ''
      substituteInPlace src/main/index.ts --replace-fail SEANIME_BIN ${lib.getExe finalAttrs.finalPackage}
    '';

    preBuild = ''
      cp -r ${
        seanime-web {
          npmBuildScript = "build:denshi";
          installPhase = ''
            runHook preInstall

            mkdir $out
            cp -r seanime-web/out-denshi $out/web-denshi

            runHook postInstall
          '';
        }
      }/web-denshi .
    '';

    env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    npmRebuildFlags = [ "--ignore-scripts" ];

    buildPhase = ''
      runHook preBuild

      npm run build:main

      mkdir native-builds
      cp -r ${mpv-prism}/. native-builds/${mpvPrismTarget}/

      ${
        if stdenv.hostPlatform.isDarwin then
          ''
            cp -r ${denshi-electron.dist}/Electron.app ./
            find ./Electron.app -name 'Info.plist' -exec chmod +rw {} \;

            npm exec electron-builder -- \
              --dir \
              -c.mac.identity=null \
              -c.electronDist=./ \
              -c.electronVersion=${denshi-electron.version} \
              -c.extraMetadata.version=v${finalAttrs.version}
          ''
        else
          ''
            npm exec electron-builder -- \
              --dir \
              -c.electronDist=${denshi-electron.dist} \
              -c.electronVersion=${denshi-electron.version} \
              -c.extraMetadata.version=v${finalAttrs.version}
          ''
      }

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      ${
        if stdenv.hostPlatform.isDarwin then
          ''
            mkdir -p $out/{Applications,bin}
            cp -r dist/mac*/"Seanime Denshi.app" $out/Applications
            makeWrapper "$out/Applications/Seanime Denshi.app/Contents/MacOS/Seanime Denshi" $out/bin/seanime-denshi
          ''
        else
          ''
            mkdir -p $out/share/seanime-denshi
            cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/seanime-denshi

            makeWrapper ${lib.getExe denshi-electron} $out/bin/seanime-denshi \
              --add-flags $out/share/seanime-denshi/resources/app.asar \
              --chdir "$out/share/seanime-denshi/resources" \
              --inherit-argv0

            for size in 16 18 24 32 48 64 128 256 512 1024; do
              install -Dm644 "assets/"$size"x"$size".png" "$out/share/icons/hicolor/"$size"x"$size"/apps/seanime-denshi.png"
            done
          ''
      }

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "seanime-denshi";
        type = "Application";
        desktopName = "Seanime Denshi";
        comment = "Desktop client for Seanime.";
        icon = "seanime-denshi";
        exec = "seanime-denshi";
        categories = [
          "AudioVideo"
          "Player"
          "Video"
        ];
      })
    ];

    meta.platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source media server for anime and manga";
    homepage = "https://seanime.app";
    changelog = "https://github.com/5rahim/seanime/blob/main/CHANGELOG.md";
    mainProgram = "seanime";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      ern775
      thegu5
    ];
  };
})
