<<<<<<< HEAD
{ stdenv, lib, fetchFromGitHub, git, linux-pam, libxcb }:

stdenv.mkDerivation rec {
  pname = "ly";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fairyglade";
    repo = "ly";
    rev = "v${version}";
    hash = "sha256-78XD6DK9aQi8hITWJWnFZ3U9zWTcuw3vtRiU3Lhu7O4=";
    fetchSubmodules = true;
  };

  hardeningDisable = [ "all" ];
  nativeBuildInputs = [ git ];
  buildInputs = [ libxcb linux-pam ];
=======
{ stdenv, lib, fetchFromGitHub, linux-pam }:

stdenv.mkDerivation rec {
  pname = "ly";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "cylgom";
    repo = "ly";
    rev = version;
    sha256 = "16gjcrd4a6i4x8q8iwlgdildm7cpdsja8z22pf2izdm6rwfki97d";
    fetchSubmodules = true;
  };

  buildInputs = [ linux-pam ];
  makeFlags = [ "FLAGS=-Wno-error" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ly $out/bin
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
<<<<<<< HEAD
    homepage = "https://github.com/fairyglade/ly";
    maintainers = [ maintainers.vidister ];
    platforms = platforms.linux;
=======
    homepage = "https://github.com/cylgom/ly";
    maintainers = [ maintainers.vidister ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
