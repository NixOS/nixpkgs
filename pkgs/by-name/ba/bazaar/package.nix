{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchFromGitLab,
  replaceVars,
  wrapGAppsHook4,
  nix-update-script,

  appstream,
  bubblewrap,
  flatpak,
  gobject-introspection,
  glycin-loaders,
  gtk4,
  json-glib,
  libadwaita,
  libdex,
  libglycin,
  libsoup_3,
  libxmlb,
  libyaml,

  blueprint-compiler,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  python3,
}:

let
  version = "2.0.2";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "glycin";
    tag = version;
    hash = "sha256-HLvdDQ1rXm2JTUwot07qOIzNaK/sK6zLswips8oIp9c=";
  };

  bwrap = lib.getExe' bubblewrap "bwrap";

  glycinPathsPatch = replaceVars ./libglycin-bind-correct-paths.patch {
    inherit bwrap;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit version src;
    pname = "libglycin";
    hash = "sha256-IaiQ1OdmlBcIYyruG6p/rrOxq7x8csF/W3ONerh2lAA=";
  };

  glycin = libglycin.overrideAttrs (
    _final: prev: {
      inherit src version cargoDeps;
      nativeBuildInputs = prev.nativeBuildInputs ++ [
        python3
      ];
      mesonFlags = prev.mesonFlags ++ [
        "-Dglycin-thumbnailer=false"
      ];

      patches = (if prev ? patches then prev.patches else [ ]) ++ [
        glycinPathsPatch
        # Otherwise the PATH will be cleared and bwrap could not be found
        ./libglycin-inherit-path.patch
        # weird known issue with unexpected versions of bubblewrap
        # https://gitlab.gnome.org/GNOME/glycin/-/issues/88
        (replaceVars ./libglycin-no-seccomp.patch {
          inherit bwrap;
        })
      ];

      postPatch = ''
        patchShebangs build-aux
      '';
    }
  );

  loaders = glycin-loaders.overrideAttrs (
    _final: prev: {
      inherit version src cargoDeps;
      cargoVendorDir = null;
      nativeBuildInputs = prev.nativeBuildInputs ++ [
        python3
      ];
      buildInputs = prev.buildInputs ++ [
        glycin
        gobject-introspection
      ];
      patches = [
        glycinPathsPatch
      ];
      mesonFlags = prev.mesonFlags ++ [
        "-Dlibglycin-gtk4=false"
      ];
      postPatch = ''
        patchShebangs build-aux
        substituteInPlace glycin-loaders/meson.build \
          --replace-fail "cargo_target_dir / rust_target / loader," "cargo_target_dir / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / loader,"
        substituteInPlace glycin-thumbnailer/meson.build \
          --replace-fail "cargo_target_dir / rust_target / 'glycin-thumbnailer'," "cargo_target_dir / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / 'glycin-thumbnailer',"
      '';
    }
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "bazaar";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "bazaar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KNQNF/uR9rGN+4/l1otqK+etA+jFtrdJ18Ecg1eaKNE=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    flatpak
    gtk4
    json-glib
    libadwaita
    libdex
    glycin
    libsoup_3
    libxmlb
    libyaml
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "$out/bin:${lib.makeBinPath [ bubblewrap ]}"
      --prefix XDG_DATA_DIRS : "${loaders}/share"
    )
  '';

  passthru = {
    inherit glycinPathsPatch;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FlatHub-first app store for GNOME";
    homepage = "https://github.com/kolunmi/bazaar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "bazaar";
    platforms = lib.platforms.linux;
  };
})
