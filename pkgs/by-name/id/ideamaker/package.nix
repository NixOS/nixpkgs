{
  stdenv,
  autoPatchelfHook,
  cacert,
  common-updater-scripts,
  curl,
  dpkg,
  fetchurl,
  fetchzip,
  lib,
  libcork,
  libGLU,
  libsForQt5,
  makeDesktopItem,
  openssl,
  shared-mime-info,
  writeShellApplication,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ideamaker";
  version = "4.3.3.6560";
  src =
    let
      semver = lib.strings.concatStringsSep "." (
        lib.lists.init (builtins.splitVersion finalAttrs.version)
      );
    in
    fetchurl {
      url = "https://download.raise3d.com/ideamaker/release/${semver}/ideaMaker_${finalAttrs.version}-ubuntu_amd64.deb";
      hash = "sha256-aTVWCTgnVKD16uhJUVz0vR7KPGJqCVj0xoL53Qi3IKM=";
    };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    shared-mime-info
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs =
    let
      # we need curl 7.47.0, as the app segfaults on launch in 7.47.1 and beyond
      # (tested with 7.47.1, 7.50.3, 7.62, 7.79.1, and 8.7.1)
      curl_7_47_0 =
        let
          openssl_1_0_1u = openssl.overrideAttrs (previous: {
            version = "1.0.1u";
            src = fetchurl {
              url = "https://www.openssl.org/source/openssl-1.0.1u.tar.gz";
              hash = "sha256-QxK0yhIVtvLJcAdQPYDbgNUVf3b499P+u+a0xW/yZzk=";
            };
            patches = [ ];
            withDocs = false;
            outputs = lib.lists.remove "doc" previous.outputs;
            meta.knownVulnerabilities = [
              "OpenSSL 1.0.1 reached its end of life 2016-12-31, see https://endoflife.software/applications/security-libraries/openssl."
              "CVE-2021-4044"
              "CVE-2016-7056"
            ];
          });
        in
        (curl.override {
          gnutlsSupport = true;
          gssSupport = false;
          http2Support = false;
          # while we use openssl, the configureFlag has since changed, so we manually set it below
          opensslSupport = false;
          pslSupport = false;
          scpSupport = false;
        }).overrideAttrs
          (previous: {
            version = "7.47.0";
            src = fetchzip {
              url = "https://curl.se/download/curl-7.47.0.tar.lzma";
              hash = "sha256-XlZk1nJbSmiQp7jMSE2QRCY4C9w2us8BgosBSzlD4dE=";
            };
            configureFlags = previous.configureFlags ++ [
              "--with-ca-bundle=${cacert}/etc/ssl/certs/ca-bundle.crt"
              "--with-ssl=${lib.getLib openssl_1_0_1u}"
            ];
            patches = [ ];
            # curl https://curl.se/docs/vuln-7.74.0.json | jq -r '.[].id' | sed 's/^/"/;s/$/"/'
            meta.knownVulnerabilities = [
              "CURL-CVE-2024-2398"
              "CURL-CVE-2023-46218"
              "CURL-CVE-2023-38546"
              "CURL-CVE-2023-38545"
              "CURL-CVE-2023-28322"
              "CURL-CVE-2023-28321"
              "CURL-CVE-2023-28320"
              "CURL-CVE-2023-27538"
              "CURL-CVE-2023-27536"
              "CURL-CVE-2023-27535"
              "CURL-CVE-2023-27534"
              "CURL-CVE-2023-27533"
              "CURL-CVE-2023-23916"
              "CURL-CVE-2022-43552"
              "CURL-CVE-2022-32221"
              "CURL-CVE-2022-35252"
              "CURL-CVE-2022-32208"
              "CURL-CVE-2022-32207"
              "CURL-CVE-2022-32206"
              "CURL-CVE-2022-32205"
              "CURL-CVE-2022-27782"
              "CURL-CVE-2022-27781"
              "CURL-CVE-2022-27776"
              "CURL-CVE-2022-27775"
              "CURL-CVE-2022-27774"
              "CURL-CVE-2022-22576"
              "CURL-CVE-2021-22947"
              "CURL-CVE-2021-22946"
              "CURL-CVE-2021-22945"
              "CURL-CVE-2021-22926"
              "CURL-CVE-2021-22925"
              "CURL-CVE-2021-22924"
              "CURL-CVE-2021-22923"
              "CURL-CVE-2021-22922"
              "CURL-CVE-2021-22898"
              "CURL-CVE-2021-22897"
              "CURL-CVE-2021-22890"
              "CURL-CVE-2021-22876"
            ];
          });
    in
    [
      (lib.getLib curl_7_47_0)
      libcork
      libGLU
      libsForQt5.qtbase
      libsForQt5.qtserialport
      libsForQt5.quazip
    ];

  installPhase = ''
    runHook preInstall

    install -D usr/lib/x86_64-linux-gnu/ideamaker/ideamaker \
      $out/bin/${finalAttrs.pname}

    patchelf --replace-needed libquazip.so.1 libquazip1-qt5.so \
      $out/bin/${finalAttrs.pname}

    mimetypeDir=$out/share/icons/hicolor/128x128/mimetypes
    mkdir -p ''$mimetypeDir
    for file in usr/share/ideamaker/icons/*.ico; do
      mv $file ''$mimetypeDir/''$(basename ''${file%.ico}).png
    done
    install -D ${./mimetypes.xml} \
      $out/share/mime/packages/${finalAttrs.pname}.xml

    install -D usr/share/ideamaker/icons/ideamaker-icon.png \
      $out/share/pixmaps/${finalAttrs.pname}.png

    ln -s ${finalAttrs.desktopItem}/share/applications $out/share/

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = finalAttrs.pname;
    exec = finalAttrs.pname;
    icon = finalAttrs.pname;
    desktopName = "Ideamaker";
    comment = "ideaMaker - www.raise3d.com";
    categories = [
      "Qt"
      "Utility"
      "3DGraphics"
      "Viewer"
      "Engineering"
    ];
    genericName = finalAttrs.meta.description;
    mimeTypes = [
      "application/x-ideamaker"
      "model/3mf"
      "model/obj"
      "model/stl"
      "text/x.gcode"
    ];
    noDisplay = false;
    startupNotify = true;
    terminal = false;
    type = "Application";
  };

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "ideamaker-update-script";
    runtimeInputs = [
      curl
      common-updater-scripts
    ];
    text = ''
      set -eu -o pipefail

      release_page=$(mktemp)
      curl -s https://www.raise3d.com/download/ideamaker-all-versions/ > "$release_page"

      latest_stable_version=$(
        sed -nE '/Beta|Alpha/! s/.*Version ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p' "$release_page" | \
          head -n 1
      )

      latest_stable_build_number=$(
        sed -nE "s/.*ideaMaker_$latest_stable_version\.([0-9]+).*/\1/p" "$release_page" | head -n 1
      )

      update-source-version ideamaker "$latest_stable_version.$latest_stable_build_number"
    '';
  });

  meta = {
    homepage = "https://www.raise3d.com/ideamaker/";
    changelog = "https://www.raise3d.com/download/ideamaker-release-notes/";
    description = "Raise3D's 3D slicer software";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
