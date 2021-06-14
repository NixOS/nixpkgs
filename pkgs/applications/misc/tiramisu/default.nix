{ lib, stdenv, fetchFromGitHub, pkg-config, glib }:

stdenv.mkDerivation {
  pname = "tiramisu";
  version = "unstable-2021-05-20";

  src = fetchFromGitHub {
    owner = "Sweets";
    repo = "tiramisu";
    rev = "e53833d0b5b0ae41ceb7dc434d8e25818fe62291";
    sha256 = "sha256-F4oaTOAQQfOkEXeBVbGH+0CHc9v9Ac08GyzHliOdAfc=";
  };

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
    maintainers = with maintainers; [ wishfort36 fortuneteller2k ];
  };
}
