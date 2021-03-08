{ lib, stdenv, fetchFromGitHub, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "tiramisu";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Sweets";
    repo = pname;
    rev = version;
    sha256 = "0aw17riwgrhsmcndzh7sw2zw8xvn3d203c2gcrqi9nk5pa7fwp9m";
  };

  postPatch = ''
    sed -i 's/printf(element_delimiter)/printf("%s", element_delimiter)/' src/output.c
  '';

  buildInputs = [ glib ];

  nativeBuildInputs = [ pkg-config ];

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
    maintainers = with maintainers; [ wishfort36 ];
  };
}
