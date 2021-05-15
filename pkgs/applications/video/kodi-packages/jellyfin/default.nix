{ lib, addonDir, buildKodiAddon, fetchFromGitHub, kodi, requests, dateutil, six, kodi-six, signals }:
let
  python = kodi.pythonPackages.python.withPackages (p: with p; [ pyyaml ]);
in
buildKodiAddon rec {
  pname = "jellyfin";
  namespace = "plugin.video.jellyfin";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-kodi";
    rev = "v${version}";
    sha256 = "0fx20gmd5xlg59ks4433qh2b3jhbs5qrnc49zi4rkqqr4jr4nhnn";
  };

  nativeBuildInputs = [
    python
  ];

  prePatch = ''
    substituteInPlace .config/generate_xml.py \
      --replace "'jellyfin-kodi/release.yaml'" "'release.yaml'" \
      --replace "'jellyfin-kodi/addon.xml'" "'addon.xml'"
  '';

  buildPhase = ''
    ${python}/bin/python3 .config/generate_xml.py py3
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
  ];

  meta = with lib; {
    homepage = "https://jellyfin.org/";
    description = "A whole new way to manage and view your media library";
    license = licenses.gpl3Only;
    maintainers = teams.kodi.members;
  };
}
