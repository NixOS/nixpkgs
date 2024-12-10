{
  stdenv,
  lib,
  fetchurl,
  cargo,
  desktop-file-utils,
  itstool,
  meson,
  ninja,
  pkg-config,
  jq,
  moreutils,
  rustc,
  wrapGAppsHook4,
  gtk4,
  lcms2,
  libadwaita,
  libgweather,
  libseccomp,
  glycin-loaders,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loupe";
  version = "47.1";

  src = fetchurl {
    url = "mirror://gnome/sources/loupe/${lib.versions.major finalAttrs.version}/loupe-${finalAttrs.version}.tar.xz";
    hash = "sha256-9gNWmpThcwHy2sNLAsEsbY48pq65vmq1uYM5P5Ve2Ho=";
  };

  patches = [
    # Fix paths in glycin library
    glycin-loaders.passthru.glycinPathsPatch
  ];

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    jq
    moreutils
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    lcms2
    libadwaita
    libgweather
    libseccomp
  ];

  postPatch = ''
    # Replace hash of file we patch in vendored glycin.
    jq \
      --arg hash "$(sha256sum vendor/glycin/src/sandbox.rs | cut -d' ' -f 1)" \
      '.files."src/sandbox.rs" = $hash' \
      vendor/glycin/.cargo-checksum.json \
      | sponge vendor/glycin/.cargo-checksum.json
  '';

  preFixup = ''
    # Needed for the glycin crate to find loaders.
    # https://gitlab.gnome.org/sophie-h/glycin/-/blob/0.1.beta.2/glycin/src/config.rs#L44
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "loupe";
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/loupe";
    changelog = "https://gitlab.gnome.org/GNOME/loupe/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Simple image viewer application written with GTK4 and Rust";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jk ] ++ teams.gnome.members;
    platforms = platforms.unix;
    mainProgram = "loupe";
  };
})
