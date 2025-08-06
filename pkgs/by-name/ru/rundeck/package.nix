{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk17,
  which,
  coreutils,
  openssh,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rundeck";
  version = "5.13.0-20250625";

  src = fetchurl {
    url = "https://packagecloud.io/pagerduty/rundeck/packages/java/org.rundeck/rundeck-${finalAttrs.version}.war/artifacts/rundeck-${finalAttrs.version}.war/download?distro_version_id=167";
    hash = "sha256-RqyJ0/gZQ1gIYSPoYfGGN5VB5ubUMl00pHPlw6v6tBQ=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk17 ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rundeck
    cp $src $out/share/rundeck/rundeck.war

    mkdir -p $out/bin
    makeWrapper ${lib.getExe jdk17} $out/bin/rundeck \
      --add-flags "-jar $out/share/rundeck/rundeck.war" \
      --prefix PATH : ${
        lib.makeBinPath [
          which
          coreutils
          openssh
        ]
      }

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-rundeck" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl jq
    set -eu -o pipefail

    latest_tag=$(curl -s "https://api.github.com/repos/rundeck/rundeck/tags" | jq -r '.[0].name')
    version=$(echo "$latest_tag" | sed -E 's/^v//')
    full_version="$version-$(date +"%Y%m%d")"

    if [[ "x$UPDATE_NIX_OLD_VERSION" != "x$full_version" ]]; then
      download_url="https://packagecloud.io/pagerduty/rundeck/packages/java/org.rundeck/rundeck-$full_version.war/artifacts/rundeck-$full_version.war/download?distro_version_id=167"
      hash=$(curl -L "$download_url" | nix-hash --flat --type sha256 --base32 - | nix --extra-experimental-features nix-command hash to-sri --type sha256)
      update-source-version "$UPDATE_NIX_ATTR_PATH" "$full_version" "$hash"
    fi
  '';

  meta = {
    description = "Job scheduler and runbook automation";
    longDescription = ''
      Rundeck is an open source automation service with a web console,
      command line tools and a WebAPI. It lets you easily run automation tasks
      across a set of nodes.
    '';
    homepage = "https://www.rundeck.com/";
    changelog = "https://docs.rundeck.com/docs/history/";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "rundeck";
  };
})
