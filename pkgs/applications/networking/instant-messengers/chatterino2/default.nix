{ stdenv, lib, cmake, pkg-config, fetchFromGitHub, qtbase, qtsvg, qtmultimedia, qtimageformats, qttools, boost, openssl, wrapQtAppsHook, libsecret }:

stdenv.mkDerivation rec {
  pname = "chatterino2";
<<<<<<< HEAD
  version = "2.4.5";
=======
  version = "2.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "Chatterino";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ughEavlvL1/mvevbYrDG+2/JYigMhVwyy3RFysQqUNs=";
=======
    sha256 = "sha256-M8WTgZv3+8SRGNfxCv10GldjgRYBUVo1B3X4s+QAuYs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [ qtbase qtsvg qtmultimedia qtimageformats qttools boost openssl libsecret ];
  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p "$out/Applications"
    mv bin/chatterino.app "$out/Applications/"
  '' + ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp $src/resources/icon.png $out/share/icons/hicolor/256x256/apps/chatterino.png
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
