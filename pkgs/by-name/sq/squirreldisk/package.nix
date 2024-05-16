{
  dbus,
  openssl,
  freetype,
  libsoup,
  gtk3,
  webkitgtk,
  pkg-config,
  wrapGAppsHook3,
  parallel-disk-usage,
  fetchFromGitHub,
  buildNpmPackage,
  rustPlatform,
  lib,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,
}: let
  pname = "squirreldisk";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "adileo";
    repo = "squirreldisk";
    rev = "v${version}";
    hash = "sha256-As2nvc68knjeLPuX0QLBoybj8vuvkpS5Vr+7U7E5CjA=";
  };
  frontend-build = buildNpmPackage {
    inherit version src;
    pname = "squirreldisk-ui";

    npmDepsHash = "sha256-Japcn0KYP7aYIDK8+Ns+mrnbbAb0fLWXHIV2+yltI6I=";

    packageJSON = ./package.json;
    postBuild = ''
      cp -r dist/ $out
    '';
    distPhase = "true";
    dontInstall = true;
  };
in
  rustPlatform.buildRustPackage rec {
    inherit version src pname;

    sourceRoot = "${src.name}/src-tauri";

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "window-shadows-0.2.1" = "sha256-3meM04TG63PvB0M5wUH1cDMBo7ObcB0zdgwGt2aKHMs=";
      };
    };

    # copy the frontend static resources to final build directory
    # Also modify tauri.conf.json so that it expects the resources at the new location
    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock

      mkdir -p frontend-build
      cp -r ${frontend-build}/* frontend-build

      substituteInPlace tauri.conf.json --replace-fail '"distDir": "../dist"' '"distDir": "./frontend-build"'

      # Copy pdu binary from nixpkgs, since the default packaged binary has issues.
      cp ${parallel-disk-usage}/bin/pdu bin/pdu-${stdenv.hostPlatform.config}
    '';

    nativeBuildInputs = [pkg-config wrapGAppsHook3 copyDesktopItems];
    buildInputs = [dbus openssl freetype libsoup gtk3 webkitgtk];

    # Disable checkPhase, since the project doesn't contain tests
    doCheck = false;

    postInstall = ''
      mv $out/bin/squirreldisk-tauri $out/bin/squirreldisk
      install -DT icons/256x256.png $out/share/icons/hicolor/256x256/apps/squirrel-disk.png
      install -DT icons/128x128@2x.png $out/share/icons/hicolor/128x128@2/apps/squirrel-disk.png
      install -DT icons/128x128.png $out/share/icons/hicolor/128x128/apps/squirrel-disk.png
      install -DT icons/32x32.png $out/share/icons/hicolor/32x32/apps/squirrel-disk.png
    '';

    # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
    postFixup = ''
      wrapProgram "$out/bin/squirreldisk" \
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "SquirrelDisk";
        exec = "squirreldisk";
        icon = "squirrel-disk";
        desktopName = "SquirrelDisk";
        comment = meta.description;
      })
    ];

    meta = with lib; {
      description = "Cross-platform disk usage analysis tool";
      homepage = "https://www.squirreldisk.com/";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [peret];
      mainProgram = "squirreldisk";
    };
  }
