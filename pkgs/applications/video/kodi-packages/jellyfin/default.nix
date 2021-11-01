{ lib, addonDir, buildKodiAddon, fetchFromGitHub, kodi, requests, dateutil, six, kodi-six, signals, websocket }:
let
  python = kodi.pythonPackages.python.withPackages (p: with p; [ pyyaml ]);
in
buildKodiAddon rec {
  pname = "jellyfin";
  namespace = "plugin.video.jellyfin";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-kodi";
    rev = "v${version}";
    sha256 = "06glhnpayldficvvhlkbxg7zizl2wqms66fnc3p63nm3y7mqa9dd";
  };

  nativeBuildInputs = [
    python
  ];

  prePatch = ''
    # ZIP does not support timestamps before 1980 - https://bugs.python.org/issue34097
    substituteInPlace build.py \
      --replace "with zipfile.ZipFile('{}/{}'.format(target, archive_name), 'w') as z:" "with zipfile.ZipFile('{}/{}'.format(target, archive_name), 'w', strict_timestamps=False) as z:"
  '';

  buildPhase = ''
    ${python}/bin/python3 build.py --version=py3
  '';

  postInstall = ''
    mv /build/source/addon.xml $out${addonDir}/${namespace}/
  '';

  propagatedBuildInputs = [
    requests
    dateutil
    six
    kodi-six
    signals
    websocket
  ];

  meta = with lib; {
    homepage = "https://jellyfin.org/";
    description = "A whole new way to manage and view your media library";
    license = licenses.gpl3Only;
    maintainers = teams.kodi.members;
  };
}
