{ stdenv, lib, cmake, pkg-config, fetchFromGitHub, qtbase, qtsvg, qtmultimedia, qtimageformats, qttools, boost, openssl, wrapQtAppsHook, libsecret }:

stdenv.mkDerivation rec {
  pname = "chatterino7";
  version = "7.4.5";
  src = fetchFromGitHub {
    owner = "SevenTV";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wLiGnNVr1n6LX6bzjqUrk99K981Kz2Mqc2ydU94t4l0=";
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

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A chat client for Twitch chat with 7tv integration";
    longDescription = ''
      Chatterino is a chat client for Twitch chat. Chatterino7 is a fork of Chatterino 2.
      This fork mainly contains features that aren't accepted into Chatterino 2, most notably 7TV subscriber features.
    '';
    homepage = "https://github.com/SevenTV/chatterino7";
    changelog = "https://github.com/SevenTV/chatterino7/blob/chatterino7/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ hauskens ];
  };
}
