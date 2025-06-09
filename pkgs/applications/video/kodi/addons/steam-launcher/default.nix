{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  steam,
  which,
  xdotool,
  dos2unix,
  wmctrl,
}:
buildKodiAddon {
  pname = "steam-launcher";
  namespace = "script.steam.launcher";
  version = "3.5.1";

  src = fetchFromGitHub rec {
    owner = "teeedubb";
    repo = owner + "-xbmc-repo";
    rev = "d5cea4b590b0ff08ac169b757946b7cb5145b983";
    sha256 = "sha256-arBMMOoHQuHRcJ7eXD1jvA45Svei7c0srcBZkdAzqY0=";
  };

  propagatedBuildInputs = [
    steam
    which
    xdotool
  ];

  postInstall = ''
    substituteInPlace $out/share/kodi/addons/script.steam.launcher/resources/main.py \
      --replace "\"which\"" "\"${which}/bin/which\"" \
      --replace "\"xdotool\"" "\"${xdotool}/bin/xdotool\"" \
      --replace "\"wmctrl\"" "\"${wmctrl}/bin/wmctrl\""
    ${dos2unix}/bin/dos2unix $out/share/kodi/addons/script.steam.launcher/resources/scripts/steam-launcher.sh
  '';

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
    teams = [ teams.kodi ];
  };
}
