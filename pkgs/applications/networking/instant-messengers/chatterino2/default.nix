{ stdenv, lib, cmake, pkg-config, fetchFromGitHub, qtbase, qtsvg, qtmultimedia, qtimageformats, qttools, boost, openssl, wrapQtAppsHook, libsecret }:

stdenv.mkDerivation rec {
  pname = "chatterino2";
  version = "2.4.6";
  src = fetchFromGitHub {
    owner = "Chatterino";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CQviw5Fw6v5EwjCldAQoJfAIZMWKBfBzUIQZEgW34k0=";
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
