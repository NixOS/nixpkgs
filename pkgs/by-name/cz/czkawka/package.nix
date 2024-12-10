{
  lib,
  stdenv,
  atk,
  cairo,
  czkawka,
  darwin,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk4,
  pango,
  pkg-config,
  rustPlatform,
  testers,
  wrapGAppsHook4,
  xvfb-run,
}:

let
  pname = "czkawka";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    hash = "sha256-SOWtLmehh1F8SoDQ+9d7Fyosgzya5ZztCv8IcJZ4J94=";
  };
  cargoHash = "sha256-GOX7V6NLEMP06nMeRZINwcWCaHwK6T3nkRKl4e25DPg=";
in
rustPlatform.buildRustPackage {
  inherit
    pname
    version
    src
    cargoHash
    ;

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [
      atk
      cairo
      gdk-pixbuf
      glib
      gtk4
      pango
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Foundation
        AppKit
      ]
    );

  nativeCheckInputs = [
    xvfb-run
  ];

  strictDeps = true;

  checkPhase = ''
    runHook preCheck
    xvfb-run cargo test
    runHook postCheck
  '';

  doCheck = stdenv.hostPlatform.isLinux && (stdenv.hostPlatform == stdenv.buildPlatform);

  passthru.tests.version = testers.testVersion {
    package = czkawka;
    command = "czkawka_cli --version";
  };

  # Desktop items, icons and metainfo are not installed automatically
  postInstall = ''
    install -Dm444 -t $out/share/applications data/com.github.qarmin.czkawka.desktop
    install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka.svg
    install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka-symbolic.svg
    install -Dm444 -t $out/share/metainfo data/com.github.qarmin.czkawka.metainfo.xml
  '';

  meta = {
    changelog = "https://github.com/qarmin/czkawka/raw/${version}/Changelog.md";
    description = "A simple, fast and easy to use app to remove unnecessary files from your computer";
    homepage = "https://github.com/qarmin/czkawka";
    license = with lib.licenses; [ mit ];
    mainProgram = "czkawka_gui";
    maintainers = with lib.maintainers; [
      AndersonTorres
      yanganto
      _0x4A6F
    ];
  };
}
