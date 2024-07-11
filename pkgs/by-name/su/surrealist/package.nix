{ buildGoModule
, cairo
, cargo
, cargo-tauri
, esbuild
, fetchFromGitHub
, gdk-pixbuf
, gobject-introspection
, lib
, libsoup
, llvmPackages_15
, makeBinaryWrapper
, nodejs
, pango
, pkg-config
, pnpm
, rustc
, rustPlatform
, stdenv
, stdenvNoCC
, wasm-bindgen-cli
, webkitgtk
}:

let

  esbuild-18-20 = let version = "0.18.20";
  in esbuild.override {
    buildGoModule = args:
      buildGoModule (args // {
        inherit version;
        src = fetchFromGitHub {
          owner = "evanw";
          repo = "esbuild";
          rev = "v${version}";
          hash = "sha256-mED3h+mY+4H465m02ewFK/BgA1i/PQ+ksUNxBlgpUoI=";
        };
        vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
      });
  };

  wasm-bindgen-cli-2-92 = wasm-bindgen-cli.override {
    version = "0.2.92";
    hash = "sha256-1VwY8vQy7soKEgbki4LD+v259751kKxSxmo/gqE6yV0=";
    cargoHash = "sha256-aACJ+lYNEU8FFBs158G1/JG8sc6Rq080PeKCMnwdpH0=";
  };

in stdenv.mkDerivation (finalAttrs: {
  pname = "surrealist";
  version = "1.11.7";

  src = fetchFromGitHub {
    owner = "StarlaneStudios";
    repo = "Surrealist";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1jTvbr7jFo2GOB79ClwtBVVnNQlSEkqY2eqbiZxWG74=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  embed = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "${finalAttrs.pname}-embed";
    sourceRoot = "${finalAttrs.src.name}/src-embed";
    auditable = false;
    dontInstall = true;

    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit (finalAttrs) src;
      sourceRoot = "${finalAttrs.src.name}/src-embed";
      hash = "sha256-0cAhaeoP8EPcE1230CyznQZZIKRs0lrI8XOXECgb8pg=";
    };

    nativeBuildInputs = [
      cargo
      rustc
      llvmPackages_15.clangNoLibc
      llvmPackages_15.lld
      rustPlatform.cargoSetupHook
      wasm-bindgen-cli-2-92
    ];

    postBuild = ''
      CC=clang cargo build \
        --target wasm32-unknown-unknown \
        --release

      wasm-bindgen \
        target/wasm32-unknown-unknown/release/surrealist_embed.wasm \
        --out-dir $out \
        --out-name surrealist-embed \
        --target web
    '';
  };

  ui = stdenvNoCC.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "${finalAttrs.pname}-ui";
    dontFixup = true;

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-3x/GKgVX0mnxTZmINe/qTtr/vI0h5IqPYt9N0l/VGzg=";
    };

    ESBUILD_BINARY_PATH = "${lib.getExe esbuild-18-20}";

    nativeBuildInputs = [ nodejs pnpm.configHook ];

    postPatch = ''
      ln -s ${finalAttrs.embed} src/generated
    '';

    postBuild = ''
      pnpm build
    '';

    postInstall = ''
      cp -r dist $out
    '';
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-localhost-0.1.0" =
        "sha256-7PJgz6t/jPEwX/2xaOe0SYawfPSZw/F1QtOrc6iPiP0=";
    };
  };

  nativeBuildInputs = [
    cargo
    cargo-tauri
    makeBinaryWrapper
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs =
    [ cairo gdk-pixbuf gobject-introspection libsoup pango webkitgtk ];

  postPatch = ''
    substituteInPlace ./tauri.conf.json \
      --replace '"distDir": "../dist",' '"distDir": "${finalAttrs.ui}",' \
      --replace '"beforeBuildCommand": "pnpm build",' '"beforeBuildCommand": "",'
  '';

  postBuild = ''
    cargo tauri build --bundles deb
  '';

  postInstall = ''
    install -Dm555 target/release/bundle/deb/surrealist_${finalAttrs.version}_*/data/usr/bin/surrealist -t $out/bin
    cp -r target/release/bundle/deb/surrealist_${finalAttrs.version}_*/data/usr/share $out
  '';

  postFixup = ''
    wrapProgram "$out/bin/surrealist" --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = with lib; {
    description = "Powerful graphical SurrealDB query playground and database explorer for Browser and Desktop";
    homepage = "https://surrealist.starlane.studio";
    license = licenses.mit;
    mainProgram = "surrealist";
    maintainers = with maintainers; [ frankp ];
    platforms = platforms.linux;
    # See comment about wasm32-unknown-unknown in rustc.nix.
    broken = lib.any (a: lib.hasAttr a stdenv.hostPlatform.gcc) [ "cpu" "float-abi" "fpu" ] ||
      !stdenv.hostPlatform.gcc.thumb or true;
  };
})
