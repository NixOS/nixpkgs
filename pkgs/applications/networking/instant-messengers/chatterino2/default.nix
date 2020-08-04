{ mkDerivation, stdenv, lib, pkgconfig, fetchFromGitHub, qtbase, qtsvg, qtmultimedia, qmake, boost, openssl, wrapQtAppsHook }:

mkDerivation rec {
  pname = "chatterino2";
  version = "2.1.7";
  src = fetchFromGitHub {
    owner = "fourtf";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bbdzainfa7hlz5p0jfq4y04i3wix7z3i6w193906bi4gr9wilpg";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ qmake pkgconfig wrapQtAppsHook ];
  buildInputs = [ qtbase qtsvg qtmultimedia boost openssl ];
  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p "$out/Applications"
    mv bin/chatterino.app "$out/Applications/"
  '';
  postFixup = lib.optionalString stdenv.isDarwin ''
    wrapQtApp "$out/Applications/chatterino.app/Contents/MacOS/chatterino"
  '';
  meta = with lib; {
    description = "A chat client for Twitch chat";
    longDescription = ''
      Chatterino is a chat client for Twitch chat. It aims to be an
      improved/extended version of the Twitch web chat. Chatterino 2 is
      the second installment of the Twitch chat client series
      "Chatterino".
  '';
    homepage = "https://github.com/fourtf/chatterino2";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rexim ];
  };
}
