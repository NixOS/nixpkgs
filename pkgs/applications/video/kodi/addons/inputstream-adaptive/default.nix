{ stdenv, lib, rel, addonDir, buildKodiBinaryAddon, fetchFromGitHub, pugixml, glib, nspr, nss, gtest, rapidjson }:
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
  version = "21.4.6";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.adaptive";
    rev = "${version}-${rel}";
    sha256 = "sha256-ub4ep89datfr8aZLZAfoz7zhOizGFpzgp2PVON6Ptj8=";
  };

  extraCMakeFlags = [
    "-DENABLE_INTERNAL_BENTO4=ON"
    "-DBENTO4_URL=${bento4}"
  ];

  extraNativeBuildInputs = [ gtest ];

  extraBuildInputs = [ pugixml rapidjson ];

  extraRuntimeDependencies = [ glib nspr nss (lib.getLib stdenv.cc.cc) ];

  extraInstallPhase = let n = namespace; in ''
    ${lib.optionalString stdenv.hostPlatform.isAarch64 "ln -s $out/lib/addons/${n}/libcdm_aarch64_loader.so $out/${addonDir}/${n}/libcdm_aarch64_loader.so"}
  '';

  meta = with lib; {
    homepage = "https://github.com/xbmc/inputstream.adaptive";
    description = "Kodi inputstream addon for several manifest types";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
