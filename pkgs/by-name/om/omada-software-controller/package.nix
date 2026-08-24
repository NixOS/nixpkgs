{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  writeScriptBin,
  bash,
  coreutils,
  curl,
  jsvc,
  mongodb-ce,
  jdk_headless,
  procps,
  which,
  testers,
  writeShellScript,
  common-updater-scripts,
  pup,
  gnugrep,
  gnused,
  dataDir ? "/var/lib/omada",
}:

let
  # Use the prebuilt MongoDB Community Edition to avoid building MongoDB from source.
  mongodb = mongodb-ce;

  # The 'arch' command is required during runtime with is equivalent to 'uname -m':
  arch = writeScriptBin "arch" "${lib.getExe' coreutils "uname"} -m";

  jsvcWithSameJdkVersion = jsvc.override {
    jdk = jdk_headless;
    jre = jdk_headless;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "omada-software-controller";
  version = "6.2.14.11";

  src = fetchurl {
    url = "https://static.tp-link.com/upload/software/2026/202607/20260717/Omada_SDN_Controller_v6.2.14.11_linux_x64.tar.gz";
    hash = "sha256-I0J/c92TBRpiCwgaq1X/zEz7IJUaAgodNXxD6CR4qnQ=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    ./control-script.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    bash
  ];

  runtimeDeps = [
    arch
    bash
    coreutils
    curl
    jdk_headless
    jsvcWithSameJdkVersion
    procps
    which
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/defaults
    cp -r ./* $out
    patchShebangs $out

    # Move away the persistable data and property directories, storing them as defaults
    mv $out/data $out/defaults/data
    mv $out/properties $out/defaults/properties

    # Remove other persistable directories and the interactive (un)install scripts
    rm -rf $out/{logs,work}
    rm -f $out/{install.sh,uninstall.sh}

    # Create links for all persisteable directories to the dataDir
    ln -s ${dataDir}/logs $out/logs
    ln -s ${dataDir}/work $out/work
    ln -s ${dataDir}/data $out/data
    ln -s ${dataDir}/properties $out/properties

    # Create link for mongod binary in expected location
    ln -s ${mongodb}/bin/mongod $out/bin/mongod

    # Create wrapped executables with different names
    makeWrapper $out/bin/control.sh $out/bin/omada \
      --prefix PATH : "${lib.makeBinPath finalAttrs.runtimeDeps}"
    makeWrapper $out/bin/control.sh $out/bin/tpeap \
      --prefix PATH : "${lib.makeBinPath finalAttrs.runtimeDeps}"

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "omada version";
      version = "v${finalAttrs.version}";
    };

    updateScript = writeShellScript "update-${finalAttrs.pname}" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          common-updater-scripts
          curl
          gnugrep
          gnused
          pup
        ]
      }:$PATH"
      NEW_DOWNLOAD_URL=$(curl -s "https://www.tp-link.com/us/support/download/omada-software-controller/" \
        | pup 'table.download-resource-table tbody tr:first-child th:nth-child(2) a attr{href}' \
        | grep -P '.*Omada_.*_v[^_]*_linux_x64.*\.tar\.gz' \
        | head -n 1)
      NEW_VERSION=$(echo "$NEW_DOWNLOAD_URL" \
        | sed -n 's/.*_v\([^_]*\)_linux_x64.*\.tar\.gz/\1/p')
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version is same as the old version."
          exit 0
      fi
      NIX_HASH=$(nix hash to-sri sha256:$(nix-prefetch-url $NEW_DOWNLOAD_URL))
      update-source-version "omada-software-controller" "$NEW_VERSION" "$NIX_HASH" "$NEW_DOWNLOAD_URL"
    '';
  };

  meta = with lib; {
    description = "Omada Software Controller";
    homepage = "https://www.tp-link.com/us/business-networking/omada-sdn-controller/omada-software-controller/";
    downloadPage = "https://www.tp-link.com/us/support/download/omada-software-controller/";
    license = licenses.unfree;
    maintainers = with maintainers; [ pathob ];
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "omada";
  };
})
