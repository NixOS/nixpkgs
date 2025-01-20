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
  openjdk17,
  procps,
  which,
  omada-sdn-controller,
  testers,
  writeShellScript,
  common-updater-scripts,
  pup,
  gnugrep,
  gnused,
  dataDir ? "/var/lib/omada",
}:

let
  # The 'arch' command is required during runtime with is equivalent to 'uname -m':
  arch = writeScriptBin "arch" "${lib.getExe' coreutils "uname"} -m";

  # Java 17 is supported, pin to avoid unsupported dependency upgrades.
  jre = openjdk17;

  # MongoDB 7 is supported with version 5.14.20 and above, pin to avoid unsupported dependency upgrades.
  mongodb = mongodb-ce.overrideAttrs (oldAttrs: {
    version = "7.0.16";

    src = fetchurl {
      url = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-7.0.16.tgz";
      hash = "sha256-N2wliumxBLiIFCFLwyFKLg0TANgZLSTYxGJZ82SGZCI=";
    };
  });
in

stdenv.mkDerivation rec {
  pname = "omada-sdn-controller";
  version = "5.15.8.2";

  src = fetchurl {
    url = "https://static.tp-link.com/upload/software/2025/202501/20250109/Omada_SDN_Controller_v5.15.8.2_linux_x64.tar.gz";
    hash = "sha256-0bz5vVdITyiinwQKiV3IPyV/igSQEbWVTxazkZIHgDk=";
  };

  patches = [
    ./control-script.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  runtimeDeps = [
    arch
    bash
    coreutils
    curl
    jre
    jsvc
    procps
    which
  ];

  unpackPhase = "tar -xzf $src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/defaults
    cp -r Omada_SDN_Controller_v${version}_linux_x64/* $out
    patchShebangs $out

    # Move away the persistable data and property directories, storing them as defaults
    mv $out/data $out/defaults/data
    mv $out/properties $out/defaults/properties

    # Remove other persistable directories
    rm -rf $out/{logs,work}

    # Create links for all persisteable directories to the dataDir
    ln -s ${dataDir}/logs $out/logs
    ln -s ${dataDir}/work $out/work
    ln -s ${dataDir}/data $out/data
    ln -s ${dataDir}/properties $out/properties

    # Create link for mongod binary in expected location
    ln -s ${mongodb}/bin/mongod $out/bin/mongod

    # Create wrapped executables with different names
    makeWrapper $out/bin/control.sh $out/bin/omada \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    makeWrapper $out/bin/control.sh $out/bin/tpeap \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = omada-sdn-controller;
      command = "omada version";
    };

    updateScript = writeShellScript "update-${pname}" ''
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
        | grep -P '.*Omada_SDN_Controller_v[^_]*_linux_x64\.tar\.gz' \
        | head -n 1)
      NEW_VERSION=$(echo "$NEW_DOWNLOAD_URL" \
        | sed -n 's/.*Controller_v\([^_]*\)_linux_x64\.tar\.gz/\1/p')
      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version is same as the old version."
          exit 0
      fi
      NIX_HASH=$(nix hash to-sri sha256:$(nix-prefetch-url $NEW_DOWNLOAD_URL))
      update-source-version "omada-sdn-controller" "$NEW_VERSION" "$NIX_HASH" "$NEW_DOWNLOAD_URL"
    '';
  };

  meta = with lib; {
    description = "Omada SDN Controller";
    homepage = "https://www.tp-link.com/us/business-networking/omada-sdn-controller/omada-software-controller/";
    downloadPage = "https://www.tp-link.com/us/support/download/omada-software-controller/";
    license = licenses.unfree;
    maintainers = with maintainers; [ pathob ];
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "omada";
  };
}
