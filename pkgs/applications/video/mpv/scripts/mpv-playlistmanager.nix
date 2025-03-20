{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
  yt-dlp,
}:

buildLua {
  pname = "mpv-playlistmanager";
  version = "0-unstable-2025-02-23";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = "mpv-playlistmanager";
    rev = "20ad0ee48af97735bf024a0f725152c60b5728cc";
    hash = "sha256-XHKLl+IGCJ1TD4OIUmQBAq8jRVmEUFQ2cFVdpG/xMMM=";
  };
  passthru.updateScript = unstableGitUpdater { };

  postPatch = ''
    substituteInPlace playlistmanager.lua \
      --replace-fail 'youtube_dl_executable = "yt-dlp",' \
      'youtube_dl_executable = "${lib.getExe yt-dlp}"',
  '';

  meta = with lib; {
    description = "Mpv lua script to create and manage playlists";
    homepage = "https://github.com/jonniek/mpv-playlistmanager";
    license = licenses.unlicense;
    maintainers = with maintainers; [ lunik1 ];
  };
}
