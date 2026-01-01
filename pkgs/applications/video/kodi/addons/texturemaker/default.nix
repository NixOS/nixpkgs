{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  jurialmunkey,
}:

buildKodiAddon rec {
  pname = "texturemaker";
  namespace = "script.texturemaker";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "jurialmunkey";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-GtUDNc0qatGzgSqQdDJgZnrhI1f+SPyoG9Og+oRFxRM=";
  };

  propagatedBuildInputs = [
    jurialmunkey
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/jurialmunkey/script.texturemaker/tree/main";
    description = "Texture Maker helps skinners build gradient based textures";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    homepage = "https://github.com/jurialmunkey/script.texturemaker/tree/main";
    description = "Texture Maker helps skinners build gradient based textures";
    license = licenses.gpl3Plus;
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
