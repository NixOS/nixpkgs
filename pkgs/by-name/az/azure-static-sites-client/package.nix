{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  curl,
  icu70,
  libkrb5,
  lttng-ust,
  openssl,
  zlib,
  azure-static-sites-client,
  # "latest", "stable" or "backup"
  versionFlavor ? "stable",
}:
let
  versions = lib.importJSON ./versions.json;
  flavor = lib.head (lib.filter (x: x.version == versionFlavor) versions);
in
stdenv.mkDerivation {
  pname = "StaticSitesClient-${versionFlavor}";
  version = flavor.buildId;

  src = fetchurl {
    url = flavor.files.linux-x64.url;
    sha256 = flavor.files.linux-x64.sha;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    curl
    icu70
    libkrb5
    lttng-ust
    openssl
    (lib.getLib stdenv.cc.cc)
    zlib
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -m755 "$src" -D "$out/bin/StaticSitesClient"

    for icu_lib in 'icui18n' 'icuuc' 'icudata'; do
      patchelf --add-needed "lib''${icu_lib}.so.${lib.head (lib.splitVersion (lib.getVersion icu70.name))}" "$out/bin/StaticSitesClient"
    done

    patchelf --add-needed 'libgssapi_krb5.so' \
             --add-needed 'liblttng-ust.so'   \
             --add-needed 'libssl.so.3'     \
             "$out/bin/StaticSitesClient"

    runHook postInstall
  '';

  # Stripping kills the binary
  dontStrip = true;

  # Just make sure the binary executes successfully
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/StaticSitesClient version

    runHook postInstallCheck
  '';

  passthru = {
    # Create tests for all flavors
    tests = lib.genAttrs (map (x: x.version) versions) (
      versionFlavor: azure-static-sites-client.override { inherit versionFlavor; }
    );
    updateScript = ./update.sh;
  };

  meta = {
    description = "Azure static sites client";
    homepage = "https://github.com/Azure/static-web-apps-cli";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "StaticSitesClient";
    maintainers = with lib.maintainers; [ veehaitch ];
    platforms = [ "x86_64-linux" ];
  };
}
