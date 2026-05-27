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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hkdb";
    repo = "aerion";
    rev = "v${version}";
    hash = "sha256-PjA3iyk9wtj/cnRcy70nV6Zf21G4LovoEz3PumjBhq8=";
  };

  frontend = buildNpmPackage {
    pname = "aerion-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-JGasC2Ehwss4S6a9QOy5JDaJZgyUsra4+ur/PaoqSGs=";

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

  vendorHash = "sha256-ptsrOpJo3i+yRSCGuHynbzi+C+GD/mBmPuHqWSVV/+4=";

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

  meta = with lib; {
    description = "An Open Source Lightweight E-Mail Client";
    homepage = "https://github.com/hkdb/aerion";
    license = licenses.asl20;
    mainProgram = "aerion";
    maintainers = with maintainers; [ curious ];
  };
}
