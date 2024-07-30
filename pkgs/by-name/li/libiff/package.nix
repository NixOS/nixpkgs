{
  stdenv,
  fetchFromGitHub,
  lib,
  autoreconfHook,
  help2man,
}:

stdenv.mkDerivation {
  pname = "libiff";
  version = "0-unstable-2024-03-02";
  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "libiff";
    rev = "b5f542a83c824f26e0816770c9a17c22bd388606";
    sha256 = "sha256-Arh3Ihd5TWg5tdemodrxz2EDxh/hwz9b2/AvrTONFy8=";
  };
  nativeBuildInputs = [
    autoreconfHook
    help2man
  ];
  meta = with lib; {
    description = "Parser for the Interchange File Format (IFF)";
    longDescription = ''
      libiff is a portable, extensible parser library implemented in
      ANSI C, for EA-IFF 85: Electronic Arts' Interchange File Format
      (IFF).
    '';
    homepage = "https://github.com/svanderburg/libiff";
    maintainers = with maintainers; [ _414owen ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
