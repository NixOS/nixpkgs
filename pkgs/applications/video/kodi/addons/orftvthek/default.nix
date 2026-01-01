{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  inputstream-adaptive,
  inputstreamhelper,
  routing,
}:

buildKodiAddon rec {
  pname = "orftvthek";
  namespace = "plugin.video.orftvthek";
<<<<<<< HEAD
  version = "1.0.3+matrix.1";
=======
  version = "1.0.2+matrix.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "s0faking";
    repo = namespace;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-HWx1Uj/yOJ5Tggyd8EJHyBfpUAbtfk89XpWTKzl6Ie0=";
=======
    sha256 = "sha256-bCVsR7lH0REJmG3OKU8mRRvw/PhSrLfhufmVBmw05+k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    # Needed for content decryption with Widevine.
    inputstream-adaptive
    inputstreamhelper
    routing
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/s0faking/plugin.video.orftvthek";
    description = "Addon for accessing the Austrian ORF ON streaming service";
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
=======
  meta = with lib; {
    homepage = "https://github.com/s0faking/plugin.video.orftvthek";
    description = "Addon for accessing the Austrian ORF ON streaming service";
    license = licenses.gpl2Only;
    teams = [ teams.kodi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
