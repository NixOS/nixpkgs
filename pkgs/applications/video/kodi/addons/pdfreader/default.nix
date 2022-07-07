{ lib, buildKodiAddon, fetchFromGitHub }:
buildKodiAddon rec {
  pname = "pdfreader";
  namespace = "plugin.image.pdf";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "i96751414";
    repo = "plugin.image.pdfreader";
    rev = "v${version}";
    sha256 = "0nkqhlm1gyagq6xpdgqvd5qxyr2ngpml9smdmzfabc8b972mwjml";
  };

  passthru.pythonPath = "lib/api";

  meta = with lib; {
    homepage = "https://forum.kodi.tv/showthread.php?tid=187421";
    description = "A comic book reader";
    license = licenses.gpl2Plus;
    maintainers = teams.kodi.members;
  };
}
