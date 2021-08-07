{ mkDerivation, stdenv, lib, pkg-config, fetchFromGitHub, qtbase, qtsvg, qtmultimedia, qmake, boost, openssl, wrapQtAppsHook }:

mkDerivation rec {
  pname = "chatterino2";
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "Chatterino";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x12zcrbkxn2nn0hqkj1amrxv4q032id282cajzsx7by970r1shd";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ qmake pkg-config wrapQtAppsHook ];
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
