{ stdenv, lib, rel, addonDir, buildKodiBinaryAddon, fetchFromGitHub, expat, glib, nspr, nss, gtest }:
buildKodiBinaryAddon rec {
  pname = "inputstream-adaptive";
  namespace = "inputstream.adaptive";
  version = "2.6.23";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.adaptive";
    rev = "${version}-${rel}";
    sha256 = "sha256-3w/fMaGqaOHSE7GUJtYoWovBKSOv3sNOIX1UOcp8hQE=";
  };

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
