{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  libv3270,
  lib3270,
  openssl,
  gettext,
  desktop-file-utils,
  wrapGAppsHook3,
  meson,
  scour,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pw3270";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "PerryWerneck";
    repo = "pw3270";
    tag = finalAttrs.version;
    hash = "sha256-thvurPyAsbcCRcanV6PwObO26LCmphdNrYYKhHDKnzE=";
  };

  nativeBuildInputs = [
    pkg-config
    desktop-file-utils
    wrapGAppsHook3
    meson
    scour
    ninja
  ];

  buildInputs = [
    gtk3
    gettext
    libv3270
    lib3270
    openssl
  ];

  postPatch = ''
    # lib3270_build_data_filename is relative to lib3270's share - not ours.
    for f in $(find . -type f -iname "*.c"); do
      sed -i -e "s@lib3270_build_data_filename(@g_build_filename(\"$out/share/pw3270\", @" "$f"
    done
  '';

  postFixup = ''
    # Schemas get installed to wrong directory.
    mkdir -p $out/share/glib-2.0
    mv $out/share/gsettings-schemas/pw3270-${finalAttrs.version}/glib-2.0/schemas $out/share/glib-2.0/
    glib-compile-schemas $out/share/glib-2.0/schemas
    rm -rf $out/share/gsettings-schemas
  '';

  enableParallelBuilding = true;

  meta = {
    description = "3270 Emulator for gtk";
    homepage = "https://softwarepublico.gov.br/social/pw3270/";
    changelog = "https://github.com/PerryWerneck/pw3270/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ vifino ];
    mainProgram = "pw3270";
  };
})
