{
  lib,
  stdenvNoCC,
  fetchurl,
  cpio,
  xar,
  writeShellApplication,
  cacert,
  curl,
  jq,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "insta360-wave-controller";
  version = "1.1.0-build7";

  # The vendor URL holds an upload hash and a build timestamp that do not
  # follow from the version, so the update script rewrites the whole URL.
  src = fetchurl {
    url = "https://wassets.insta360.com/common/85661444411946edb17399282f5b0683/Insta360WaveController_1.1.0(build7)_20261008_101106_signed_1791425478377.pkg";
    name = "insta360-wave-controller-${finalAttrs.version}.pkg";
    hash = "sha256-9jlYFF5tZYoClvYjLHd2cS99xSXYXaEfXWMt9J/S/h0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cpio
    xar
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf $src
    zcat Insta360_Wave_Controller.pkg/Payload | cpio -i

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R "Applications/Insta360 Wave Controller.app" $out/Applications

    runHook postInstall
  '';

  # The app is signed and notarized; fixup would invalidate the signature.
  dontFixup = true;

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "insta360-wave-controller-update-script";
    runtimeInputs = [
      cacert
      curl
      jq
      common-updater-scripts
    ];
    # app_id 144 is the "Desktop Software" entry of the Insta360 Wave group.
    text = ''
      release=$(
        curl --silent --fail "https://openapi.insta360.com/app/appDownload/getGroupApp?group=insta360-wave&X-Language=en-us" |
          jq --exit-status '
            .data.apps[] | select(.app_id == 144)
            | [.items[] | select(.platform == "mac")]
            | max_by(.version | [scan("[0-9]+") | tonumber])
          '
      )
      version=$(jq --exit-status --raw-output '.version // empty | sub("_"; "-")' <<<"$release")
      url=$(jq --exit-status --raw-output '.channels[] | select(.channel == "official") | .download_url // empty' <<<"$release")
      update-source-version insta360-wave-controller "$version" "" "$url"
    '';
  });

  meta = {
    description = "Controller for Insta360 Wave devices";
    homepage = "https://www.insta360.com/download/insta360-wave";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ NoobInTheNet ];
    platforms = lib.platforms.darwin;
  };
})
