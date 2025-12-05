{
  lib,
  atk,
  cairo,
  callPackage,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk4,
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
  self = rustPlatform.buildRustPackage {
    pname = "czkawka";
    version = "10.0.0";

    src = fetchFromGitHub {
      owner = "qarmin";
      repo = "czkawka";
      tag = self.version;
      hash = "sha256-r6EdTv95R8+XhaoA9OeqnGGl09kz8kMJaDPDRV6wQe8=";
    };

    cargoHash = "sha256-o4XjHJ7eCckTXqjz1tS4OSCP8DZzjxfWoMMy5Gab2rI=";

    nativeBuildInputs = [
      gobject-introspection
      pkg-config
      wrapGAppsHook4
    ];

    buildInputs = [
      atk
      cairo
      gdk-pixbuf
      glib
      gtk4
      pango
    ];

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
    versionCheckProgramArg = "--version";
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
