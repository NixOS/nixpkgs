{
  lib,
  stdenvNoCC,
  fetchurl,

  xz,
  zlib,
  libusb1,
  segger-jlink-headless,
  gcc,

  autoPatchelfHook,
  versionCheckHook,
  makeWrapper,
  installShellFiles,

  symlinkJoin,
  extensions ? [ ],
  nrfutil,
}:

let
  sources = import ./source.nix;
  platformSources =
    sources.${stdenvNoCC.system} or (throw "unsupported platform ${stdenvNoCC.system}");

  sharedMeta = with lib; {
    description = "CLI tool for managing Nordic Semiconductor devices";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Util";
    changelog = "https://docs.nordicsemi.com/bundle/nrfutil/page/guides/revision_history.html";
    license = licenses.unfree;
    platforms = lib.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      h7x4
      ezrizhu
    ];
  };

  packages =
    map
      (
        name:
        let
          package = platformSources.packages.${name};
        in
        stdenvNoCC.mkDerivation (finalAttrs: {
          pname = name;
          inherit (package) version;

          src = fetchurl {
            url = "https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/packages/${name}/${name}-${platformSources.triplet}-${package.version}.tar.gz";
            inherit (package) hash;
          };

          nativeBuildInputs = [
            autoPatchelfHook
          ];

          buildInputs = [
            xz
            zlib
            libusb1
            gcc.cc.lib
            segger-jlink-headless
          ];

          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out
            mv data/* $out/

            runHook postInstall
          '';

          doInstallCheck = true;
          nativeInstallCheckInputs = [
            versionCheckHook
          ];
          versionCheckProgramArg = "--version";

          meta = sharedMeta // {
            mainProgram = name;
          };
        })
      )
      (
        [
          "nrfutil"
          "nrfutil-completion"
        ]
        ++ extensions
      );

in
symlinkJoin {
  pname = "nrfutil";
  inherit (platformSources.packages.nrfutil) version;

  paths = packages;

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postBuild =
    let
      wrapProgramArgs = lib.concatStringsSep " " (
        [
          ''--prefix PATH : "$out/bin"''
          ''--prefix PATH : "$out"/lib/nrfutil-npm''
          ''--prefix PATH : "$out"/lib/nrfutil-nrf5sdk-tools''
          ''--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libusb1 ]}''
          ''--set NRF_JLINK_DLL_PATH '${segger-jlink-headless}'/lib/libjlinkarm.so''
          ''--set NRFUTIL_BLE_SNIFFER_SHIM_BIN_ENV "$out"/lib/nrfutil-ble-sniffer/wireshark-shim''
          ''--set NRFUTIL_BLE_SNIFFER_HCI_SHIM_BIN_ENV "$out"/lib/nrfutil-ble-sniffer/wireshark-hci-shim''
        ]
        ++ (
          let
            # These are the extensions with the probe-plugin-worker executable vendored.
            relevantExtensions = lib.intersectLists [ "nrfutil-device" "nrfutil-trace" ] extensions;
          in
          lib.optionals (relevantExtensions != [ ]) [
            ''--set NRF_PROBE_PATH "$out"/lib/${lib.head relevantExtensions}''
          ]
        )
      );
    in
    ''
      wrapProgram "$out"/bin/nrfutil ${wrapProgramArgs}

      installShellCompletion --cmd nrfutil \
        --bash $(realpath "$out"/share/nrfutil-completion/scripts/bash/setup.bash) \
        --zsh $(realpath "$out"/share/nrfutil-completion/scripts/zsh/_nrfutil)
    '';

  passthru = {
    updateScript = ./update.sh;
    withExtensions = extensions: nrfutil.override { inherit extensions; };
  };

  meta = sharedMeta // {
    mainProgram = "nrfutil";
  };
}
