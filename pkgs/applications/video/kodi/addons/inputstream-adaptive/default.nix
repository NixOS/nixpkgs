{ stdenv, lib, rel, addonDir, buildKodiBinaryAddon, fetchFromGitHub, expat, glib, nspr, nss, gtest }:
let
  bento4 = fetchFromGitHub {
    owner = "xbmc";
    repo = "Bento4";
<<<<<<< HEAD
    rev = "1.6.0-639-7-Omega";
    sha256 = "sha256-d3znV88dLMbA4oUWsTZ7vS6WHOWzN7lIHgWPkR5Aixo=";
=======
    rev = "1.6.0-639-5-${rel}";
    sha256 = "sha256-jjeBy3LmnN7hPjnbBSPcdtPD+MdbG+0kU8mekM2/ZFw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
buildKodiBinaryAddon rec {
  pname = "inputstream-adaptive";
  namespace = "inputstream.adaptive";
<<<<<<< HEAD
  version = "20.3.9";
=======
  version = "20.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.adaptive";
    rev = "${version}-${rel}";
<<<<<<< HEAD
    sha256 = "sha256-Z5p/lw7qg6aacJ0eSqswaiwTOsUmuDbNlRRs51LdjRw=";
=======
    sha256 = "sha256-QG0qBRbUJJgsRLS2cQIDeTDYLjqVD0dRaZ7pCxpxNcs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  extraCMakeFlags = [
    "-DENABLE_INTERNAL_BENTO4=ON"
    "-DBENTO4_URL=${bento4}"
  ];

  extraNativeBuildInputs = [ gtest ];

  extraBuildInputs = [ expat ];

  extraRuntimeDependencies = [ glib nspr nss stdenv.cc.cc.lib ];

  extraInstallPhase = let n = namespace; in ''
    ln -s $out/lib/addons/${n}/libssd_wv.so $out/${addonDir}/${n}/libssd_wv.so
  '';

  meta = with lib; {
    homepage = "https://github.com/xbmc/inputstream.adaptive";
    description = "Kodi inputstream addon for several manifest types";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
