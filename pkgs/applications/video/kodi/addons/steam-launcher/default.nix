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
  version = "3.7.11";

  src = fetchFromGitHub rec {
    owner = "teeedubb";
    repo = owner + "-xbmc-repo";
    rev = "8d0972909c3f1d0cd9e435e77f8b1f59314d52f0";
    sha256 = "IYxl6X20qcnr1D/pNMOKBW9FfH9cXYon4Qi+wd7EvtI=";
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
