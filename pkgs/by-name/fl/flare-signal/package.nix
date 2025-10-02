{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  runCommand,
  cargo,
  meson,
  ninja,
  pkg-config,
  gst_all_1,
  protobuf,
  libspelling,
  libsecret,
  libadwaita,
  gtksourceview5,
  rustPlatform,
  rustc,
  yq,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  wrapGAppsHook4,
}:

let
  presage = fetchFromGitHub {
    owner = "whisperfish";
    repo = "presage";
    # match with commit from Cargo.toml
    rev = "123c1f926e359c21b34d099279ee8a92462ce96d";
    hash = "sha256-qKpPbK5ToFnWucujDlV8qxeT+XrRGYYnm7jp8UOXgZ0=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "flare";
  # NOTE: also update presage commit
  version = "0.17.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "schmiddi-on-mobile";
    repo = "flare";
    tag = finalAttrs.version;
    hash = "sha256-Zdzs9ZLvrI5rGhC1K0SLPsv/xMtJEu5vFRnH3+z/keA=";
  };

  cargoDeps =
    let
      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-XBUpFQy68qwrKgsKi5TeoakalNLTqolv6z5YfyiaEZI=";
      };
    in
    # Replace with simpler solution:
    # https://github.com/NixOS/nixpkgs/pull/432651#discussion_r2312796706
    # depending on sqlx release and update in flare-signal
    runCommand "${finalAttrs.pname}-${finalAttrs.version}-vendor-patched" { inherit cargoDeps; }
      # https://github.com/flathub/de.schmidhuberj.Flare/commit/b1352087beaf299569c798bc69e31660712853db
      # bash
      ''
        mkdir $out
        find $cargoDeps -maxdepth 1 -exec sh -c "ln -s {} $out/\$(basename {})" \;
        rm $out/presage-store-sqlite-*
        cp -r $cargoDeps/presage-store-sqlite-* $out
        chmod +w $out/presage-store-sqlite-*
        ln -s ${presage}/.sqlx $out/presage-store-sqlite-*
      '';

  nativeBuildInputs = [
    appstream # for appstream-util
    blueprint-compiler
    desktop-file-utils # for update-desktop-database
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
    # yq contains tomlq
    yq
  ];

  postPatch = ''
    cargoPresageRev="$(tomlq -r '.dependencies.presage.rev' Cargo.toml)"
    actualPresageRev="${presage.rev}"
    if [ "$cargoPresageRev" != "$actualPresageRev" ]; then
      echo ""
      echo "fetchFromGitHub presage revision does not match revision specified in Cargo.toml"
      echo "consider replacing fetchFromGitHub's revision with revision specified in Cargo.toml"
      echo ""
      echo "  fetchFromGitHub = ''${actualPresageRev}"
      echo "  Cargo.toml = ''${cargoPresageRev}"
      echo ""
      exit 1
    fi
  '';

  buildInputs = [
    gtksourceview5
    libadwaita
    libsecret
    libspelling
    protobuf

    # To reproduce audio messages
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  meta = {
    changelog = "https://gitlab.com/schmiddi-on-mobile/flare/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Unofficial Signal GTK client";
    mainProgram = "flare";
    homepage = "https://gitlab.com/schmiddi-on-mobile/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
})
