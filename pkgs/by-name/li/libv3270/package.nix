{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, which
, pkg-config
, gtk3
, lib3270
}:

stdenv.mkDerivation rec {
  pname = "libv3270";
  version = "5.4";

  src = fetchFromGitHub {
    owner = "PerryWerneck";
    repo = pname;
    rev = version;
    hash = "sha256-Z3FvxPa1pfeECxfB5ZL6gwhkbTKFpfO3D/zLVLF+uiI=";
  };

  nativeBuildInputs = [
    which
    pkg-config
    autoconf
    automake
    libtool
  ];

  buildInputs = [
    gtk3
    lib3270
  ];

  postPatch = ''
    # lib3270_build_data_filename is relative to lib3270's share - not ours.
    for f in $(find . -type f -iname "*.c"); do
      sed -i -e "s@lib3270_build_data_filename(@g_build_filename(\"$out/share/pw3270\", @" "$f"
    done
  '';

  preConfigure = ''
    mkdir -p scripts
    touch scripts/config.rpath
    NOCONFIGURE=1 sh ./autogen.sh
  '';

  enableParallelBuilds = true;

  meta = with lib; {
    description = "3270 Virtual Terminal for GTK";
    homepage = "https://github.com/PerryWerneck/libv3270";
    changelog = "https://github.com/PerryWerneck/libv3270/blob/master/CHANGELOG";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.vifino ];
  };
}
