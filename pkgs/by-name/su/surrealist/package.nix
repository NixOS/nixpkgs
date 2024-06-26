{
  buildGoModule,
  cairo,
  cargo,
  cargo-tauri,
  esbuild,
  fetchFromGitHub,
  gdk-pixbuf,
  gobject-introspection,
  lib,
  libsoup,
  makeBinaryWrapper,
  nodejs,
  openssl,
  pango,
  pkg-config,
  pnpm,
  rustc,
  rustPlatform,
  stdenv,
  stdenvNoCC,
  webkitgtk,
}:

let

  esbuild-20-2 =
    let
      version = "0.20.2";
    in
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args
          // {
            inherit version;
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-h/Vqwax4B4nehRP9TaYbdixAZdb1hx373dNxNHvDrtY=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        );
    };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "surrealist";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealist";
    rev = "surrealist-v${finalAttrs.version}";
    hash = "sha256-5OiVqn+ujssxXZXC6pnGiG1Nw8cAhoDU5IIl9skywBw=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  ui = stdenvNoCC.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "${finalAttrs.pname}-ui";

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-apvU7nanzueaF7PEQL7EKjVT5z1M6I7PZpEIJxfKuCQ=";
    };

    ESBUILD_BINARY_PATH = "${lib.getExe esbuild-20-2}";

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    buildPhase = ''
      runHook preBuild

      pnpm build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src sourceRoot version;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-uE4r0smgSbl4l77/MsHtn1Ar5fqspsYcLC/u8TUrcu8=";
  };

  nativeBuildInputs = [
    cargo
    cargo-tauri
    makeBinaryWrapper
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    gobject-introspection
    libsoup
    openssl
    pango
    webkitgtk
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postPatch = ''
    substituteInPlace ./tauri.conf.json \
      --replace-fail '"distDir": "../dist",' '"distDir": "${finalAttrs.ui}",' \
      --replace-fail '"beforeBuildCommand": "pnpm build",' '"beforeBuildCommand": "",'
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
    description = "Surrealist is the ultimate way to visually manage your SurrealDB database";
    homepage = "https://surrealdb.com/surrealist";
    license = licenses.mit;
    mainProgram = "surrealist";
    maintainers = with maintainers; [ frankp ];
    platforms = platforms.linux;
  };
})
