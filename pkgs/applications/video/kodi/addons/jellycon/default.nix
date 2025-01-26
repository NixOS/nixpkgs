{
  lib,
  addonDir,
  buildKodiAddon,
  fetchFromGitHub,
  kodi,
  requests,
  dateutil,
  six,
  kodi-six,
  signals,
  websocket,
}:
let
  python = kodi.pythonPackages.python.withPackages (p: with p; [ pyyaml ]);
in
buildKodiAddon rec {
  pname = "jellycon";
  namespace = "plugin.video.jellycon";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-60my7Y60KV5WWALQiamnmAJZJi82cV21rIGYPiV7T+A=";
  };

  nativeBuildInputs = [
    python
  ];

  prePatch = ''
    # ZIP does not support timestamps before 1980 - https://bugs.python.org/issue34097
    substituteInPlace build.py \
      --replace "with zipfile.ZipFile(f'{target}/{archive_name}', 'w') as z:" "with zipfile.ZipFile(f'{target}/{archive_name}', 'w', strict_timestamps=False) as z:"
  '';

  buildPhase = ''
    ${python}/bin/python3 build.py --version=py3
  '';

  postInstall = ''
    cp -v addon.xml $out${addonDir}/$namespace/
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
    homepage = "https://github.com/jellyfin/jellycon";
    description = "Lightweight Kodi add-on for Jellyfin";
    longDescription = ''
      JellyCon is a lightweight Kodi add-on that lets you browse and play media
      files directly from your Jellyfin server within the Kodi interface. It can
      easily switch between multiple user accounts at will.
    '';
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
