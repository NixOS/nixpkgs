{ stdenv, fetchFromGitHub, patch, meson, ninja, ... }:

stdenv.mkDerivation rec {
  pname = "ksmtuned";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ksmtuned";
    repo = "ksmtuned";
    rev = "v${version}";
    sha256 = "188j4i14ldqs8bvbzl9mqhxdz5wxxic73i7rdffpsvr2sy0hncwv";
  };

  patches = [ ./ksmtuned.patch ];

  nativeBuildInputs = [ meson ninja ];

  meta = with stdenv.lib; {
    description = "ksmtuned daemon for KSM merge tuning.";
    homepage = "https://github.com/ksmtuned/ksmtuned";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kmcopper ];
    platforms = platforms.linux;
  };
}
