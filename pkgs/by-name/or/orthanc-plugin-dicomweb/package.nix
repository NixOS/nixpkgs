{
  lib,
  stdenv,
  fetchhg,
  fetchurl,
  orthanc,
  cmake,
  python3,
  unzip,
  gtest,
  jsoncpp,
  boost,
  pugixml,
  libuuid,
  zlib,
}:

let
  bootstrap = fetchurl {
    url = "https://orthanc.uclouvain.be/downloads/third-party-downloads/bootstrap-5.3.3.zip";
    hash = "sha256-VdfxznlQQK+4MR3wnSnQ00ZIQAweqrstCi7SIWs9sF0=";
  };
  vuejs = fetchurl {
    url = "https://orthanc.uclouvain.be/downloads/third-party-downloads/dicom-web/vuejs-2.6.10.tar.gz";
    hash = "sha256-49kAzZJmtb7Zu21XX8mrZ4fnnnrSHAHuEne/9UUxIfI=";
  };
  axios = fetchurl {
    url = "https://orthanc.uclouvain.be/downloads/third-party-downloads/dicom-web/axios-0.19.0.tar.gz";
    hash = "sha256-KVd8YIWwkLTkqZOS/N1YL7a7y0myqvLMe3+jh0Ups4A=";
  };
  font-awesome = fetchurl {
    url = "https://orthanc.uclouvain.be/downloads/third-party-downloads/dicom-web/Font-Awesome-4.7.0.tar.gz";
    hash = "sha256-3lEroOHerTgrv843LN50s/GJcdh2//tjXukzPw2wXUM=";
  };
  babel-polyfill = fetchurl {
    url = "https://orthanc.uclouvain.be/downloads/third-party-downloads/dicom-web/babel-polyfill-6.26.0.min.js.gz";
    hash = "sha256-CH09LWISr7QY9QSRhY9/BVy1Te+2NR1sXQCPZioqlcI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "orthanc-plugin-dicomweb";
  version = "1.20";

  src = fetchhg {
    url = "https://orthanc.uclouvain.be/hg/orthanc-dicomweb/";
    rev = "OrthancDicomWeb-${finalAttrs.version}";
    hash = "sha256-p1n4YAFC3W2B2YYsFm/1cJ/zqLsrycJgkMrcXFf/3Xk=";
  };

  postPatch = ''
    mkdir -p ThirdPartyDownloads
    ln -s ${bootstrap} ThirdPartyDownloads/bootstrap-5.3.3.zip
    ln -s ${vuejs} ThirdPartyDownloads/vuejs-2.6.10.tar.gz
    ln -s ${axios} ThirdPartyDownloads/axios-0.19.0.tar.gz
    ln -s ${font-awesome} ThirdPartyDownloads/Font-Awesome-4.7.0.tar.gz
    ln -s ${babel-polyfill} ThirdPartyDownloads/babel-polyfill-6.26.0.min.js.gz
  '';

  SourceRoot = "${finalAttrs.src.name}/Build";

  nativeBuildInputs = [
    cmake
    python3
    unzip
  ];

  buildInputs = [
    orthanc
    orthanc.framework
    jsoncpp
    boost
    gtest
    libuuid
    pugixml
    zlib
  ];

  strictDeps = true;

  NIX_LDFLAGS = lib.strings.concatStringsSep " " [
    "-L${lib.getLib gtest}"
    "-lgtest"
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DSTATIC_BUILD=OFF"
    "-DORTHANC_FRAMEWORK_SOURCE=system"
    "-DORTHANC_FRAMEWORK_ROOT=${orthanc.framework}/include/orthanc-framework"
  ];

  meta = {
    description = "Plugin that extends Orthanc with support for the DICOMweb protocols";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dvcorreia
    ];
    platforms = lib.platforms.linux;
  };
})
