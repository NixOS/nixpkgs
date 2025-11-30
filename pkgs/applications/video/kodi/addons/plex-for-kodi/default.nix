{
  lib,
  addonDir,
  buildKodiAddon,
  fetchFromGitHub,
  addonUpdateScript,
  kodi-six,
  six,
  requests,
}:

buildKodiAddon rec {
  pname = "plex";
  namespace = "script.plex";
  version = "0.7.9-rev4";

  src = fetchFromGitHub {
    owner = "pannal";
    repo = "plex-for-kodi";
    rev = "v${version}";
    sha256 = "sha256-rNxTz3SKHHBm0WDCoZ/foJN2pBBiyI3a/tOdQdOCuXA=";
  };

  # Plex for Kodi writes to its own directory by default, needs to be patched to a non-store path.
  # Once https://github.com/pannal/plex-for-kodi/pull/219 is merged, this can be replaced with a smaller patch that just sets the environment variable INSTALLATION_DIR_AVOID_WRITE, e.g. adding to main.py:
  # import os; os.environ("INSTALLATION_DIR_AVOID_WRITE") = True
  patches = [ ./plex-template-dir.patch ];

  propagatedBuildInputs = [
    six
    requests
    kodi-six
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.plex";
    };
  };

  postInstall = ''
    mv /build/source/addon.xml $out${addonDir}/${namespace}/
  '';

  meta = with lib; {
    homepage = "https://www.plex.tv";
    description = "Unofficial Plex for Kodi add-on";
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
