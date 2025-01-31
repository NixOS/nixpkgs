{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtool }:

stdenv.mkDerivation rec {
  version="1.41";
  pname = "mxt-app";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${version}";
    sha256 = "sha256-Sn83k04ctwyVH90wnPIFuH91epPgLt1mWY+07r5eKpk=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

  hardeningDisable = [ "fortify" ];

  meta = with lib; {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = "https://github.com/atmel-maxtouch/mxt-app";
    license = licenses.bsd2;
    maintainers = [ maintainers.colemickens ];
    platforms = platforms.linux;
    mainProgram = "mxt-app";
  };
}
