{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  kodi,
  inputstreamhelper,
}:

buildKodiAddon rec {
  pname = "sendtokodi";
  namespace = "plugin.video.sendtokodi";
  version = "0.9.557";

  src = fetchFromGitHub {
    owner = "firsttris";
    repo = "plugin.video.sendtokodi";
    rev = "v${version}";
    hash = "sha256-Ga+9Q7x8+sEmQmteHbSyCahZ/T/l28BAEM84w7bf7z8=";
  };

  patches = [
    # Unconditionally depend on packaged yt-dlp. This removes the ability to
    # use youtube_dl, which is unmaintained and considered vulnerable (see
    # CVE-2024-38519).
    ./use-packaged-yt-dlp.patch
  ];

  propagatedBuildInputs = [
    inputstreamhelper
  ];

  postPatch = ''
    # Remove vendored youtube-dl and yt-dlp libraries.
    rm -r lib/
  '';

  passthru = {
    # Instead of the vendored libraries, we propagate yt-dlp via the Python
    # path.
    pythonPath = with kodi.pythonPackages; makePythonPath [ yt-dlp ];
  };

  meta = with lib; {
    homepage = "https://github.com/firsttris/plugin.video.sendtokodi";
    description = "Plays various stream sites on Kodi using yt-dlp";
    license = licenses.mit;
    maintainers = teams.kodi.members ++ [ maintainers.pks ];
  };
}
