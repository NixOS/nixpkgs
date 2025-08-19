{
  stdenv,
  lib,
  rel,
  addonDir,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  pugixml,
  glib,
  nspr,
  nss,
  gtest,
  rapidjson,
}:
let
  bento4 = fetchFromGitHub {
    owner = "xbmc";
    repo = "Bento4";
    tag = "1.6.0-641-3-${rel}";
    hash = "sha256-ycWQvXgr1DQ3Wng73S8i6y6XmcUD/iN8OKfO1czgsnY=";
  };
in
buildKodiBinaryAddon rec {
  pname = "inputstream-adaptive";
  namespace = "inputstream.adaptive";
  version = "21.5.13";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.adaptive";
    tag = "${version}-${rel}";
    hash = "sha256-XcRg0FtoN7SXRVEBWM9gIlLOMGT3x64s9WD12UJdblw=";
  };

  extraCMakeFlags = [
    "-DENABLE_INTERNAL_BENTO4=ON"
    "-DBENTO4_URL=${bento4}"
  ];

  extraNativeBuildInputs = [ gtest ];

  extraBuildInputs = [
    pugixml
    rapidjson
  ];

  extraRuntimeDependencies = [
    glib
    nspr
    nss
    (lib.getLib stdenv.cc.cc)
  ];

  extraInstallPhase =
    let
      n = namespace;
    in
    ''
      ${lib.optionalString stdenv.hostPlatform.isAarch64 "ln -s $out/lib/addons/${n}/libcdm_aarch64_loader.so $out/${addonDir}/${n}/libcdm_aarch64_loader.so"}
    '';

  meta = with lib; {
    homepage = "https://github.com/xbmc/inputstream.adaptive";
    description = "Kodi inputstream addon for several manifest types";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    teams = [ teams.kodi ];
  };
}
