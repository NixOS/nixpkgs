{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
}:
buildKodiAddon rec {
  pname = "pdfreader";
  namespace = "plugin.image.pdf";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "i96751414";
    repo = "plugin.image.pdfreader";
    rev = "v${version}";
    sha256 = "sha256-J93poR5VO9fAgNCEGftJVYnpXOsJSxnhHI6TAJZ2LeI=";
  };

  passthru.pythonPath = "lib/api";

  meta = with lib; {
    homepage = "https://forum.kodi.tv/showthread.php?tid=187421";
    description = "Comic book reader";
    license = licenses.gpl2Plus;
    teams = [ teams.kodi ];
  };
}
