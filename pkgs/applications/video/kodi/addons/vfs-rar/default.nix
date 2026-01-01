{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  tinyxml,
}:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "vfs.rar";
  version = "20.1.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-8IEYA2gNchCa7O9kzrCbO5DxYWJqPzQN3SJIr9zCWc8=";
  };

  extraBuildInputs = [ tinyxml ];

<<<<<<< HEAD
  meta = {
    description = "RAR archive Virtual Filesystem add-on for Kodi";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    description = "RAR archive Virtual Filesystem add-on for Kodi";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
