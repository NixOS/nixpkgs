{
  autoPatchelfHook,
  dpkg,
  fetchurl,
  lib,
  stdenv,
  systemdLibs,
  ultraleap-hand-tracking-service,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openxr-layer-ultraleap";
  version = "1.6.5+2486adf9.CI1130164";

  src = fetchurl {
    url = "https://repo.ultraleap.com/apt/pool/main/o/openxr-layer-ultraleap/openxr-layer-ultraleap_1.6.5%2B2486adf9.CI1130164_amd64.deb";
    hash = "sha256-OWPJCk55DNnuA8kUmzqG0FIChSnbwBQhWRBUripM7Yo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    stdenv.cc.cc
    systemdLibs
    ultraleap-hand-tracking-service
  ];

  strictDeps = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -d "$out/lib"
    cp -Tr "usr/lib/openxr-layer-ultraleap" "$out/lib"

    install -d "$out/share/doc"
    cp -Tr "usr/share/doc" "$out/share/doc"

    local layer_path="share/openxr/1/api_layers/implicit.d/XrApiLayer_Ultraleap.json"
    install -Dm644 "usr/$layer_path" "$out/$layer_path"
    substituteInPlace "$out/$layer_path" \
      --replace-fail \
        "/usr/lib/openxr-layer-ultraleap/libUltraleapHandTracking.so.1.6.5.0" \
        "$out/lib/libUltraleapHandTracking.so.1.6.5.0"

    runHook postInstall
  '';

  meta = {
    description = "Ultraleap Hand Tracking OpenXR layer";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      Scrumplex
      pandapip1
    ];
  };
})
