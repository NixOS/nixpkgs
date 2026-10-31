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
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "hkdb";
    repo = "aerion";
    rev = "v${version}";
    hash = "sha256-LeYOgP1aLWBB2lRkaBOMT3LfqXk0uuQxNnkKfooqWC8=";
  };

  frontend = buildNpmPackage {
    pname = "aerion-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-a4N34fzmFMZoafX1rXUyeSAm12uV7njfhRkq3KT8h+I=";

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

  vendorHash = "sha256-2NxgmklHScpcF4aOLPPzuVZZ2Qhmx/7SrCGnJtJ/x54=";

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
    # Never built on darwin since first introduction in nixpkgs
    # Fails to link on Darwin with undefined `_OBJC_CLASS_$_UTType`
    # (likely requires linking `UniformTypeIdentifiers.framework`)
    broken = stdenv.hostPlatform.isDarwin;
  };
}
