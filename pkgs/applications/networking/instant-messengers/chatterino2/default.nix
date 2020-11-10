{ mkDerivation, stdenv, lib, pkgconfig, fetchFromGitHub, qtbase, qtsvg, qtmultimedia, qmake, boost, openssl, wrapQtAppsHook }:

mkDerivation rec {
  pname = "chatterino2";
  version = "2.2.2";
  src = fetchFromGitHub {
    owner = "Chatterino";
    repo = pname;
    rev = "v${version}";
    sha256 = "026cs48hmqkv7k4akbm205avj2pn3x1g7q46chwa707k9km325dz";
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
    homepage = "https://github.com/Chatterino/chatterino2";
    changelog = "https://github.com/Chatterino/chatterino2/blob/master/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rexim ];
  };
}
