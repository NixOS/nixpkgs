{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  stdenvNoCC,
  pkg-config,
  openssl,
  dbus,
  zenity,
  cargo-tauri,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  kdePackages,
  libsoup_3,
  libayatana-appindicator,
  webkitgtk_4_1,
  wrapGAppsHook3,
  pnpm_9,
  nodejs,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  version = "1.4.9";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "gui-client-${version}";
    hash = "sha256-nOf7+48WUzQ7VmP7PFo07ZhtgyG7VOI/Hb/rXyBU5o0=";
  };

  frontend = stdenvNoCC.mkDerivation rec {
    pname = "firezone-gui-client-frontend";
    inherit version src;

    pnpmDeps = pnpm_9.fetchDeps {
      inherit pname version;
      src = "${src}/rust/gui-client";
      hash = "sha256-9ywC920EF6UxkXHs+0WWaU8fr5J35/C+0nNGbSVHESE=";
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
  cargoHash = "sha256-ltxyI3Xoute0/HHXYU4XdFjcQ9zSLx6ZzAZFEjDk6zw=";
  sourceRoot = "${src.name}/rust";
  buildAndTestSubdir = "gui-client";
  RUSTFLAGS = "--cfg system_certs";

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    openssl
    dbus
    gdk-pixbuf
    glib
    gobject-introspection
    gtk3
    libsoup_3

    libayatana-appindicator
    webkitgtk_4_1
  ];

  # Required to remove profiling arguments which conflict with this builder
  postPatch = ''
    rm .cargo/config.toml
    ln -s ${frontend} gui-client/dist
  '';

  # Tries to compile apple specific crates due to workspace dependencies,
  # not sure if this can be worked around
  doCheck = false;

  desktopItems = [
    # Additional desktop item to associate deep-links
    (makeDesktopItem {
      name = "firezone-client-gui-deep-link";
      exec = "firezone-client-gui open-deep-link %U";
      icon = "firezone-client-gui";
      comment = meta.description;
      desktopName = "Firezone GUI Client";
      categories = [ "Network" ];
      noDisplay = true;
      mimeTypes = [
        "x-scheme-handler/firezone-fd0020211111"
      ];
    })
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Otherwise blank screen, see https://github.com/tauri-apps/tauri/issues/9304
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      --prefix PATH ":" ${
        lib.makeBinPath [
          zenity
          kdePackages.kdialog
        ]
      }
      --prefix LD_LIBRARY_PATH ":" ${
        lib.makeLibraryPath [
          libayatana-appindicator
        ]
      }
    )
  '';

  passthru = {
    inherit frontend;

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "gui-client-(.*)"
      ];
    };
  };

  meta = {
    description = "GUI client for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "firezone-gui-client";
  };
}
