{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

stdenv.mkDerivation rec {
  pname = "blackfire";
  version = "2026.9.0";

  src =
    passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform for blackfire: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    dpkg
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    if ${lib.boolToString stdenv.hostPlatform.isLinux}
    then
      dpkg-deb -x $src $out
      mv $out/usr/* $out
      rmdir $out/usr

      # Fix ExecStart path and replace deprecated directory creation method,
      # use dynamic user.
      substituteInPlace "$out/lib/systemd/system/blackfire-agent.service" \
        --replace-fail '/usr/' "$out/" \
        --replace-fail 'ExecStartPre=/bin/mkdir -p /var/run/blackfire' 'RuntimeDirectory=blackfire' \
        --replace-fail 'ExecStartPre=/bin/chown blackfire: /var/run/blackfire' "" \
        --replace-fail 'User=blackfire' 'DynamicUser=yes' \
        --replace-fail 'PermissionsStartOnly=true' ""

      # Modernize socket path.
      substituteInPlace "$out/etc/blackfire/agent" \
        --replace-fail '/var/run' '/run'
    else
      mkdir $out

      tar -zxvf $src

      mv etc $out
      mv usr/* $out
    fi

    runHook postInstall
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_amd64.deb";
        hash = "sha256-mm93TmfrSMP5+hVtWQ2CkUqmDqYraL4H7NVLXZ7xDqs=";
      };
      "i686-linux" = fetchurl {
        url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_i386.deb";
        hash = "sha256-nz0YYTdH0Rcs4f0aJu8Bkg/NwLNxiFwSq8kkRoa+VEA=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_arm64.deb";
        hash = "sha256-RTTNU3c9gJQRh8vjrCnhPh/mKWKs9jHUd3gund3UZWM=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://packages.blackfire.io/blackfire/${version}/blackfire-darwin_arm64.pkg.tar.gz";
        hash = "sha256-xa9lqDOVS0uPLeAyQ3fvkp3SNN8Hhv66gitjgKk/p6M=";
      };
    };

    updateScript = writeShellScript "update-blackfire" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl -s https://blackfire.io/api/v1/releases | jq .cli --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "blackfire" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Profiler agent and client";
    homepage = "https://blackfire.io/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ spk ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "aarch64-darwin"
    ];
  };
}
