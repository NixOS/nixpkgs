{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript, kodi, inputstreamhelper }:

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
    ./use-packaged-deps.patch
  ];

  propagatedBuildInputs = [
    inputstreamhelper
  ];

  postPatch = ''
    # Remove vendored youtube-dl and yt-dlp libraries.
    rm -r lib/
  '';

  passthru = {
    # Instead of the vendored libraries, we propagate youtube-dl and yt-dlp via
    # the Python path.
    pythonPath = with kodi.pythonPackages; makePythonPath [ youtube-dl yt-dlp ];
  };

  meta = with lib; {
    homepage = "https://github.com/firsttris/plugin.video.sendtokodi";
    description = "Plays various stream sites on Kodi using youtube-dl";
    license = licenses.mit;
    maintainers = teams.kodi.members ++ [ maintainers.pks ];
  };
}
