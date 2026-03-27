{
  lib,
  atk,
  cairo,
  callPackage,
  fetchFromGitHub,
  fontconfig,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk4,
  libglvnd,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  pango,
  pkg-config,
  rustPlatform,
  stdenv,
  testers,
  wayland,
  wrapGAppsHook4,
  xvfb-run,
  versionCheckHook,
}:

let
  self = rustPlatform.buildRustPackage {
    pname = "czkawka";
    version = "11.0.1";

    src = fetchFromGitHub {
      owner = "qarmin";
      repo = "czkawka";
      tag = self.version;
      hash = "sha256-ke6N3vuKPGolfh6XpAg3/9dtwd09eX53fN2klUwwNwQ=";
    };

    cargoHash = "sha256-fx2ZH4I2WYCdMgNoKQuBBEJrPjmgTRPeVM2L+TWYn54=";

    nativeBuildInputs = [
      gobject-introspection
      pkg-config
      wrapGAppsHook4
    ];

    buildInputs = [
      atk
      cairo
      fontconfig
      gdk-pixbuf
      glib
      gtk4
      pango
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libglvnd
      libxkbcommon
      wayland
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
    dontWrapGApps = true;

    postFixup = ''
      wrapGApp $out/bin/czkawka_gui
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --add-rpath "${
        lib.makeLibraryPath [
          fontconfig
          libglvnd
          libx11
          libxcursor
          libxi
          libxrandr
          libxkbcommon
          wayland
        ]
      }" $out/bin/krokiet
    '';

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgram = "${placeholder "out"}/bin/czkawka_cli";
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
