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
  versionCheckHook,
}:

let
  buildRustPackage' = rustPlatform.buildRustPackage.override {
    stdenv = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
  };

  self = buildRustPackage' {
    pname = "czkawka";
    version = "9.0.0";

    src = fetchFromGitHub {
      owner = "qarmin";
      repo = "czkawka";
      tag = self.version;
      hash = "sha256-ePiHDfQ1QC3nff8uWE0ggiTuulBomuoZ3ta0redUYXY=";
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-Djvb5Hen6XPm6aJuwa6cGPojz9+kXXidysr3URDwDFM=";

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

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgram = "${placeholder "out"}/bin/czkawka_cli";
    versionCheckProgramArg = [ "--version" ];
    doInstallCheck = true;

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
        yanganto
        _0x4A6F
      ];
    };
  };
in
self
