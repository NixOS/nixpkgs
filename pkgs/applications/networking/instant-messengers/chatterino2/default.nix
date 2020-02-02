{ mkDerivation, stdenv, lib, pkgconfig, fetchFromGitHub, qtbase, qtsvg, qtmultimedia, qmake, boost, openssl, wrapQtAppsHook }:

mkDerivation rec {
  pname = "chatterino2";
  version = "unstable-2019-05-11";
  src = fetchFromGitHub {
    owner = "fourtf";
    repo = pname;
    rev = "8c46cbf571dc8fd77287bf3186445ff52b1d1aaf";
    sha256 = "0i2385hamhd9i7jdy906cfrd81cybw524j92l87c8pzrkxphignk";
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
