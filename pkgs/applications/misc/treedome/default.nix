{ lib
, cargo-tauri
, cmake
, dbus
, fetchFromGitea
, fetchYarnDeps
, freetype
, gsettings-desktop-schemas
, gtk3
, libsoup
, mkYarnPackage
, openssl
, pkg-config
, rustPlatform
, webkitgtk
, wrapGAppsHook
, sqlite
}:

let
  pname = "treedome";
  version = "0.3.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "solver-orgz";
    repo = "treedome";
    rev = "${version}";
    hash = lib.fakeSha256;
  };

  frontend-build = mkYarnPackage {
    inherit version src;
    pname = "treedome-ui";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      sha256 = "sha256-rV5jKKnbMutaG5o8gRKgs/uoKwbIkxAPIcx6VWG7mm4=";
    };

    packageJSON = "${src}/package.json";

    configurePhase = ''
      ln -s $node_modules node_modules
    '';

    buildPhase = ''
      export HOME=$(mktemp -d)
      yarn --offline run build

      mkdir -p $out/dist
      cp -r dist/** $out/dist
    '';

    distPhase = "true";
    dontInstall = true;
  };
in
rustPlatform.buildRustPackage {
  inherit version pname src;
  sourceRoot = "src-tauri";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fix-path-env-0.0.0" = "sha256-ewE3CwqLC8dvi94UrQsWbp0mjmrzEJIGPDYtdmQ/sGs=";
    };
  };

  # copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    mkdir -p dist
    cp -R ${frontend-build}/dist/** dist

    ls -al
    substituteInPlace ./tauri.conf.json --replace '"distDir": "../dist",' '"distDir": "dist",'
    substituteInPlace ./tauri.conf.json --replace '"beforeBuildCommand": "yarn run build",' '"beforeBuildCommand": "",'
  '';

  nativeBuildInputs = [ cmake pkg-config cargo-tauri wrapGAppsHook ];
  buildInputs = [ dbus openssl freetype libsoup gtk3 webkitgtk gsettings-desktop-schemas sqlite ];

  buildPhase = ''
    runHook preBuild

    cargo tauri build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    mkdir -p $out/share/

    cp target/release/bundle/deb/treedome_0.0.0_amd64/data/usr/bin/treedome $out/bin/treedome
    cp -R target/release/bundle/deb/treedome_0.0.0_amd64/data/usr/share/** $out/share/

    runHook postInstall
  '';

  # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
  postInstall = ''
    wrapProgram "$out/bin/treedome" \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = with lib; {
    description = "A local-first, encrypted, note taking application with tree-like structures, all written and saved in markdown";
    homepage = "https://gitlab.com/treedome/treedome";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "treedome";
    maintainers = with maintainers; [ tengkuizdihar ];
  };
}
