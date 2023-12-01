{ lib, stdenv, fetchFromGitHub, pkg-config, glib, vala }:

stdenv.mkDerivation rec {
  pname = "tiramisu";
  version = "2.0.20211107";

  src = fetchFromGitHub {
    owner = "Sweets";
    repo = pname;
    rev = version;
    sha256 = "1n1x1ybbwbanibw7b90k7v4cadagl41li17hz2l8s2sapacvq3mw";
  };

  buildInputs = [ glib ];

  nativeBuildInputs = [ pkg-config vala ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Desktop notifications, the UNIX way";
    longDescription = ''
      tiramisu is a notification daemon based on dunst that outputs notifications
      to STDOUT in order to allow the user to process notifications any way they
      prefer.
    '';
    homepage = "https://github.com/Sweets/tiramisu";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wishfort36 moni ];
  };
}
