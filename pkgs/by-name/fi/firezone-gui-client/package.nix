{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  dbus,
  openssl,
  zenity,
  cargo-tauri,
  at-spi2-atk,
  atkmm,
  cairo,
  glib-networking,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  harfbuzz,
  librsvg,
  kdialog,
  libsoup_3,
  pango,
  webkitgtk_4_1,
  wrapGAppsHook3,
  stdenvNoCC,
  git,
  pnpm_9,
  nodejs,
}:
let
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "gui-client-${version}";
    hash = "sha256-gwlkHTFVd1gHwOOIar+5+LEP2ovoyEIMmLfPxYb/OCs=";
    postFetch = ''
      ${lib.getExe git} -C $out apply ${./0000-add-hyper-tls-dependency.patch}
    '';
  };

  frontend = stdenvNoCC.mkDerivation rec {
    pname = "firezone-gui-client-frontend";
    inherit version src;

    pnpmDeps = pnpm_9.fetchDeps {
      inherit pname version;
      src = "${src}/rust/gui-client";
      hash = "sha256-Gc+X4mbpHa8b/Ol6Fee7VFpTPG25LksoAEjFww1WH5I=";
    };
    pnpmRoot = "rust/gui-client";

    nativeBuildInputs = [
      pnpm_9.configHook
      nodejs
    ];

    buildPhase = ''
      runHook preBuild

      cd $pnpmRoot
      cp node_modules/flowbite/dist/flowbite.min.js src/
      pnpm tailwindcss -i src/input.css -o src/output.css
      node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage rec {
  pname = "firezone-gui-client";
  inherit version src;

  useFetchCargoVendor = true;
  cargoHash = "sha256-eqkYwP14kca7Q/P9wc+CvTBmKETTmbd06EBNx3MKLro=";
  sourceRoot = "${src.name}/rust";
  buildAndTestSubdir = "gui-client";

  nativeBuildInputs = [
    cargo-tauri.hook

    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    dbus
    gdk-pixbuf
    glib
    gobject-introspection
    gtk3
    libsoup_3
    webkitgtk_4_1

    # TODO: do not accept PR while this is in here. For Tauri to work we might also need these, not sure yet:
    # at-spi2-atk
    # atkmm
    # cairo
    # glib-networking
    # harfbuzz
    # librsvg
    # pango
  ];

  # Required to remove profiling arguments which conflict with this builder
  postPatch = ''
    rm .cargo/config.toml
    ln -s ${frontend} gui-client/dist
  '';

  # Required to run tests
  preCheck = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  checkFlags = [
    # Requires network access
    "--skip=notifiers"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${
      lib.makeBinPath [
        zenity
        kdialog
      ]
    })
  '';

  passthru = {
    inherit frontend;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "GUI client for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ oddlama ];
    mainProgram = "firezone-gui-client";
  };
}
