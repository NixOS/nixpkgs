{ lib
, stdenv
, fetchFromGitHub
, which
, pkg-config
, automake
, autoconf
, libtool
, gtk3
, libv3270
, lib3270
, openssl
, gettext
, desktop-file-utils
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "pw3270";
  version = "5.4";

  src = fetchFromGitHub {
    owner = "PerryWerneck";
    repo = pname;
    rev = version;
    hash = "sha256-Nk/OUqrWngKgb1D1Wi8q5ygKtvuRKUPhPQaLvWi1Z4g=";
  };

  nativeBuildInputs = [
    which
    pkg-config
    autoconf
    automake
    libtool
    desktop-file-utils
    wrapGAppsHook3
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

  preConfigure = ''
    NOCONFIGURE=1 sh autogen.sh
  '';

  postFixup = ''
    # Schemas get installed to wrong directory.
    mkdir -p $out/share/glib-2.0
    mv $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas $out/share/glib-2.0/
    rm -rf $out/share/gsettings-schemas
  '';

  enableParallelBuilds = true;

  meta = with lib; {
    description = "3270 Emulator for gtk";
    homepage = "https://softwarepublico.gov.br/social/pw3270/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.vifino ];
    mainProgram = "pw3270";
  };
}
