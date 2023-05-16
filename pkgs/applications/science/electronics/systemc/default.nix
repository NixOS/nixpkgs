<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "systemc";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "accellera-official";
    repo = pname;
    rev = version;
    sha256 = "0sj8wlkp68cjhmkd9c9lvm3lk3sckczpz7w9vby64inc1f9fnf0b";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--with-unix-layout" ];

=======
{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "systemc";
  version = "2.3.3";

  src = fetchurl {
    url = "https://www.accellera.org/images/downloads/standards/systemc/${pname}-${version}.tar.gz";
    sha256 = "5781b9a351e5afedabc37d145e5f7edec08f3fd5de00ffeb8fa1f3086b1f7b3f";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "The language for System-level design, modeling and verification";
    homepage    = "https://systemc.org/";
    license     = licenses.asl20;
<<<<<<< HEAD
    platforms   = platforms.linux;
    maintainers = with maintainers; [ victormignot amiloradovsky ];
=======
    maintainers = with maintainers; [ victormignot ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
