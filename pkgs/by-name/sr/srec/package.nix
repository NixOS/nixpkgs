{ lib, clangStdenv, fetchFromGitHub }:
let
  pname = "srec";
  version = "0-unstable-2015-03-06";
in
clangStdenv.mkDerivation {

  inherit pname version;

  src = fetchFromGitHub {
    owner = "arkku";
    repo = "srec";
    rev = "4bf276fd8abc2b3e57ef0e0b7c44dcacd8d810ee";
    hash = "sha256-HnQ64CPOA7m4FkMIRI3bx8kySY6uUihVKlfKYqxufSc=";
  };

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin2srec "$out/bin"
    cp srec2bin "$out/bin"
  '';

  meta = {
    description = "Binaries to convert Motorola SREC (S-Record) hex files";
    homepage = "https://github.com/arkku/srec";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ simoneruffini ];
  };
}
