{ lib, stdenvNoCC, fetchFromGitHub, yt-dlp }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-playlistmanager";
<<<<<<< HEAD
  version = "unstable-2023-08-09";
=======
  version = "unstable-2022-08-26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
<<<<<<< HEAD
    rev = "e479cbc7e83a07c5444f335cfda13793681bcbd8";
    sha256 = "sha256-Nh4g8uSkHWPjwl5wyqWtM+DW9fkEbmCcOsZa4eAF6Cs=";
=======
    rev = "07393162f7f78f8188e976f616f1b89813cec741";
    sha256 = "sha256-Vgh5F6c90ijp5LVrP2cdAOXo+QtJ9aXI9G/3C2HGqd4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace playlistmanager.lua \
<<<<<<< HEAD
      --replace 'youtube_dl_executable = "youtube-dl",' \
      'youtube_dl_executable = "${lib.getBin yt-dlp}/bin/yt-dlp"',
=======
      --replace "youtube-dl" "${lib.getBin yt-dlp}/bin/yt-dlp"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -t $out/share/mpv/scripts playlistmanager.lua
    runHook postInstall
  '';

  passthru.scriptName = "playlistmanager.lua";

  meta = with lib; {
    description = "Mpv lua script to create and manage playlists";
    homepage = "https://github.com/jonniek/mpv-playlistmanager";
    license = licenses.unlicense;
    platforms = platforms.all;
    maintainers = with maintainers; [ lunik1 ];
  };
}
