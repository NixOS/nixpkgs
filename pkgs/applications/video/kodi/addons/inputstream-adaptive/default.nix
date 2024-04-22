{ stdenv, lib, rel, addonDir, buildKodiBinaryAddon, fetchFromGitHub, pugixml, glib, nspr, nss, gtest }:
let
  bento4 = fetchFromGitHub {
    owner = "xbmc";
    repo = "Bento4";
    rev = "1.6.0-641-${rel}";
    sha256 = "sha256-vsFMDzH8JJecYw0qWKGCxnd/m5wn62mCKE2g2HwQhwI=";
  };
in
buildKodiBinaryAddon rec {
  pname = "inputstream-adaptive";
  namespace = "inputstream.adaptive";
  version = "21.4.4";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.adaptive";
    rev = "${version}-${rel}";
    sha256 = "sha256-Nzlm1AW/nW9chQAourKF0o2FSQmsr1MNhJ4gEO0/9sM=";
  };

  extraCMakeFlags = [
    "-DENABLE_INTERNAL_BENTO4=ON"
    "-DBENTO4_URL=${bento4}"
  ];

  extraNativeBuildInputs = [ gtest ];

  extraBuildInputs = [ pugixml ];

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
