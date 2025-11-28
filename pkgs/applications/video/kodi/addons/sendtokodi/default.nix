{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  kodi,
  inputstreamhelper,
  requests,
  deno,
}:

buildKodiAddon rec {
  pname = "sendtokodi";
  namespace = "plugin.video.sendtokodi";
  version = "0.9.924";

  src = fetchFromGitHub {
    owner = "firsttris";
    repo = "plugin.video.sendtokodi";
    tag = "v${version}";
    hash = "sha256-ycp5/NbRX2rcRRpbpX6LlplyxdfoIwCw39EyQDcyzOU=";
  };

  patches = [
    # Use yt-dlp, only. This removes the ability to use youtube_dl, which is
    # unmaintained and considered vulnerable (see CVE-2024-38519).
    ./use-yt-dlp-only.patch
  ];

  propagatedBuildInputs = [
    inputstreamhelper
    requests
  ];

  postPatch = ''
    # Remove youtube-dl, which is unmaintained and vulnerable.
    rm -r lib/youtube_dl lib/youtube_dl_version
    # Replace yt-dlp with our own packaged version thereof.
    rm -r lib/yt_dlp
    echo "${lib.strings.getVersion kodi.pythonPackages.yt-dlp}" >lib/yt_dlp_version
    ln -s ${kodi.pythonPackages.yt-dlp}/${kodi.pythonPackages.python.sitePackages}/yt_dlp lib/
  '';

  passthru.pathPackages = [ deno ];

  meta = with lib; {
    homepage = "https://github.com/firsttris/plugin.video.sendtokodi";
    description = "Plays various stream sites on Kodi using yt-dlp";
    license = licenses.mit;
    maintainers = [ maintainers.pks ];
    teams = [ teams.kodi ];
  };
}
