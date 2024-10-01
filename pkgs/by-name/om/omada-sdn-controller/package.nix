{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  writeScriptBin,
  coreutils,
  curl,
  jsvc,
  openjdk17,
  mongodb-ce,
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
  arch = writeScriptBin "arch" "uname -m";

  # Java 17 is supported, pin to avoid unsupported dependency upgrades.
  jre = openjdk17;

  # MongoDB 7 is supported with version 5.14.20 and above, pin to avoid unsupported dependency upgrades.
  mongodb = mongodb-ce.overrideAttrs (oldAttrs: {
    version = "7.0.14";
  });
in

stdenv.mkDerivation rec {
  pname = "omada-sdn-controller";
  version = "5.14.26.1";

  src = fetchurl {
    url = "https://static.tp-link.com/upload/software/2024/202407/20240710/Omada_SDN_Controller_v5.14.26.1_linux_x64.tar.gz";
    hash = "sha256-hVQlbFTCcFoIbBDajCOdbg3m3OgXnIej3OBlbHL374E=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  runtimeDeps = [
    arch
    coreutils
    curl
    jre
    jsvc
  ];

  unpackPhase = "tar -xzf $src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r Omada_SDN_Controller_v${version}_linux_x64/* $out
    patchShebangs $out

    # Move away the property and data directories, storing them as defaults,
    # and create links for them to the data directory
    mv $out/properties $out/properties.defaults
    ln -s ${dataDir}/properties $out/properties
    mv $out/data $out/data.defaults
    ln -s ${dataDir}/data $out/data

    # Adjust the data directory to point to a writeable path
    sed -i "s|^OMADA_HOME=.*|OMADA_HOME=\"${dataDir}\"|" $out/bin/control.sh

    # Modify the file paths in properties to make sure they point to data directory
    sed -i "s|\.\./|${dataDir}/|" $out/properties.defaults/omada.properties
    sed -i "s|\.\./|${dataDir}/|" $out/properties.defaults/log4j2.properties

    # Adjust the control script and let it provide all files in the data directory
    # structure as expected, which includes copying the initial packages files to the
    # data directory and linking packages libraries into the data directory,
    # right after the check whether the current user has root permissions.
    sed -i -e "/^check_root_perms$/a \\
    mkdir -p ${dataDir} \\
    [ ! -d "${dataDir}/properties" ] && cp -r $out/properties.defaults ${dataDir}/properties \\
    chmod +w -R ${dataDir}/properties \\
    [ ! -d "${dataDir}/data" ] && cp -r $out/data.defaults ${dataDir}/data \\
    chmod +w -R ${dataDir}/data \\
    ln -sfn $out/lib ${dataDir}/lib" $out/bin/control.sh

    # Install mongod binary in expected location
    install -Dm 755 ${mongodb}/bin/mongod $out/bin/mongod

    # Create executable with proper names
    ln -s $out/bin/control.sh $out/bin/omada
    ln -s $out/bin/control.sh $out/bin/tpeap

    # Wrap program to have runtime dependencies in path
    wrapProgram "$out/bin/omada" \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    wrapProgram "$out/bin/tpeap" \
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
      NEW_DOWNLOAD_URL=$(curl -s "${meta.homepage}" \
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
      update-source-version "${pname}" "$NEW_VERSION" "$NIX_HASH" "$NEW_DOWNLOAD_URL"
    '';
  };

  meta = with lib; {
    description = "Omada SDN Controller";
    homepage = "https://www.tp-link.com/us/support/download/omada-software-controller/";
    license = licenses.unfree;
    maintainers = with maintainers; [ pathob ];
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "omada";
  };
}
