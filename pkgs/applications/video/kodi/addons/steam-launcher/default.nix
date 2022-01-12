{ lib, buildKodiAddon, fetchFromGitHub, steam }:
buildKodiAddon {
  pname = "steam-launcher";
  namespace = "script.steam.launcher";
  version = "3.5.1";

  src = fetchFromGitHub rec {
    owner = "teeedubb";
    repo = owner + "-xbmc-repo";
    rev = "8260bf9b464846a1f1965da495d2f2b7ceb81d55";
    sha256 = "1fj3ry5s44nf1jzxk4bmnpa4b9p23nrpmpj2a4i6xf94h7jl7p5k";
  };

  propagatedBuildInputs = [ steam ];

  meta = with lib; {
    homepage = "https://forum.kodi.tv/showthread.php?tid=157499";
    description = "Launch Steam in Big Picture Mode from Kodi";
    longDescription = ''
      This add-on will close/minimise Kodi, launch Steam in Big
      Picture Mode and when Steam BPM is exited (either by quitting
      Steam or returning to the desktop) Kodi will
      restart/maximise. Running pre/post Steam scripts can be
      configured via the addon.
    '';
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
