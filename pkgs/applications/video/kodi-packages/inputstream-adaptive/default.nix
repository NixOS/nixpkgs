{ stdenv, lib, rel, addonDir, buildKodiBinaryAddon, fetchFromGitHub, expat, glib, nspr, nss, gtest }:
buildKodiBinaryAddon rec {
  pname = "inputstream-adaptive";
  namespace = "inputstream.adaptive";
  version = "19.0.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.adaptive";
    rev = "${version}-${rel}";
    sha256 = "sha256-o3tiNEVc17RIlEgf3V2oOK04da0DpmexT9m8m/xtI4I=";
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
