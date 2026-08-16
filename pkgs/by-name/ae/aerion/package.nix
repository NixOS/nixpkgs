{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  webkitgtk_4_1,
  glib,

  aerion-creds,
  withOAuth ? false,
}:

let
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "hkdb";
    repo = "aerion";
    rev = "v${version}";
    hash = "sha256-erBpAeDi5liSDLkzTCOhht8UxIX7eyTIOGwqBTMMWMQ=";
  };

  frontend = buildNpmPackage {
    pname = "aerion-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-lIlnMIGjFEDvC0ktP88bYMMoDyghtr6SlxaJmfq0Z7o=";

    buildPhase = ''
      npm run build
    '';

    installPhase = ''
      mkdir -p $out
      cp -r dist/* $out/
    '';
  };

in
buildGoModule {
  pname = "aerion";
  inherit version src;

  __structuredAttrs = true;

  vendorHash = "sha256-4zAFF4hlCrVWgvmmyoyZzBtgFd1pVRoFl8Wg0FbmM+g=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    webkitgtk_4_1
    glib
  ];

  tags = [
    "production"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "desktop"
    "webkit2_41"
  ];

  preBuild = ''
    mkdir -p frontend/dist
    cp -r ${frontend}/* frontend/dist/
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux (
    ''
      install -Dm644 build/linux/aerion.png $out/share/pixmaps/io.github.hkdb.Aerion.png
      install -Dm644 build/linux/aerion.desktop $out/share/applications/io.github.hkdb.Aerion.desktop
    ''
    + lib.optionalString withOAuth ''
      rm -f $out/bin/aerion-creds
      ln -s ${aerion-creds}/bin/aerion-creds $out/bin/aerion-creds
    ''
  );

  passthru = {
    inherit frontend;
    updateScript = ./update.sh;
  };

  meta = {
    description = "An Open Source Lightweight E-Mail Client";
    homepage = "https://github.com/hkdb/aerion";
    license = lib.licenses.asl20;
    mainProgram = "aerion";
    maintainers = with lib.maintainers; [ curious ];
  };
}
