{ stdenv, fetchFromGitHub, pkg-config, cmake, gtk3, wxGTK30-gtk3,
  curl, gettext, glib, indilib, libnova, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "phd2";
  version = "2.6.9dev1";

  src = fetchFromGitHub {
    owner = "OpenPHDGuiding";
    repo = "phd2";
    rev = "v${version}";
    sha256 = "1ih7m9lilh12xbhmwm9kkicaqy72mi3firl6df7m5x38n2zj3zm4";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook ];
  buildInputs = [ gtk3 wxGTK30-gtk3 curl gettext glib indilib libnova ];

  cmakeFlags = [
    "-DOPENSOURCE_ONLY=1"
  ];

  # Fix broken wrapped name scheme by moving wrapped binary to where wrapper expects it
  postFixup = ''
    mv $out/bin/.phd2.bin-wrapped $out/bin/.phd2-wrapped.bin
  '';

  meta = with stdenv.lib; {
    homepage = "https://openphdguiding.org/";
    description = "Telescope auto-guidance application";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = [ "x86_64-linux" ];
  };
}
