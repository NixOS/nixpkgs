{
  lib,
  atk,
  cairo,
  callPackage,
  darwin,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk4,
  overrideSDK,
  pango,
  pkg-config,
  rustPlatform,
  stdenv,
  testers,
  wrapGAppsHook4,
  xvfb-run,
}:

let
  buildRustPackage' = rustPlatform.buildRustPackage.override {
    stdenv = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
  };

  self = buildRustPackage' {
    pname = "czkawka";
    version = "7.0.0";

    src = fetchFromGitHub {
      owner = "qarmin";
      repo = "czkawka";
      rev = self.version;
      hash = "sha256-SOWtLmehh1F8SoDQ+9d7Fyosgzya5ZztCv8IcJZ4J94=";
    };

    cargoPatches = [
      # Updates time and time-macros from Cargo.lock
      ./0000-time.diff
    ];

    cargoHash = "sha256-cQv8C0P3xizsvnJODkTMJQA98P4nYSCHFT75isJE6es=";

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
          AppKit
          Foundation
        ]
      );

    nativeCheckInputs = [ xvfb-run ];

    strictDeps = true;

    doCheck = stdenv.hostPlatform.isLinux && (stdenv.hostPlatform == stdenv.buildPlatform);

    checkPhase = ''
      runHook preCheck
      xvfb-run cargo test
      runHook postCheck
    '';

    # Desktop items, icons and metainfo are not installed automatically
    postInstall = ''
      install -Dm444 -t $out/share/applications data/com.github.qarmin.czkawka.desktop
      install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka.svg
      install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka-symbolic.svg
      install -Dm444 -t $out/share/metainfo data/com.github.qarmin.czkawka.metainfo.xml
    '';

    passthru = {
      tests.version = testers.testVersion {
        package = self;
        command = "czkawka_cli --version";
      };
      wrapper = callPackage ./wrapper.nix {
        czkawka = self;
      };
    };

    meta = {
      homepage = "https://github.com/qarmin/czkawka";
      description = "Simple, fast and easy to use app to remove unnecessary files from your computer";
      changelog = "https://github.com/qarmin/czkawka/raw/${self.version}/Changelog.md";
      license = with lib.licenses; [ mit ];
      mainProgram = "czkawka_gui";
      maintainers = with lib.maintainers; [
        AndersonTorres
        yanganto
        _0x4A6F
      ];
    };
  };
in
self
