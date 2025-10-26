{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk11,
  atlassian-plugin-sdk,
  testers,
  writeShellScript,
  common-updater-scripts,
  curl,
  jq,
  yq,
}:

let
  mavenGroupIdUrl = "https://packages.atlassian.com/maven/public/com/atlassian/amps";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "atlassian-plugin-sdk";
  version = "9.9.1";

  src = fetchurl {
    url = "${mavenGroupIdUrl}/atlassian-plugin-sdk/${finalAttrs.version}/atlassian-plugin-sdk-${finalAttrs.version}.tar.gz";
    hash = "sha256-6svtGwk9d+/ipPHy/1kCQ5kyt1v9uaTwjYv6/ncCStc=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk11 ];

  unpackPhase = "tar -xzf $src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r atlassian-plugin-sdk-${finalAttrs.version}/* $out
    rm $out/bin/*.bat

    for file in "$out"/bin/*; do
      wrapProgram $file --set JAVA_HOME "${jdk11}"
    done

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = atlassian-plugin-sdk;
      command = "atlas-version";
      version = "atlassian-plugin-sdk-${finalAttrs.version}";
    };

    updateScript = writeShellScript "update-atlassian-plugin-sdk" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          yq
          common-updater-scripts
        ]
      }:$PATH"

      NEW_VERSION=$(curl -sL ${mavenGroupIdUrl}/atlassian-plugin-sdk/maven-metadata.xml | xq -r '.metadata.versioning.latest')

      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      DOWNLOAD_URL="${mavenGroupIdUrl}/atlassian-plugin-sdk/${finalAttrs.version}/atlassian-plugin-sdk-$NEW_VERSION.tar.gz"
      NIX_HASH=$(nix --extra-experimental-features nix-command hash to-sri sha256:$(nix-prefetch-url $DOWNLOAD_URL))

      update-source-version "atlassian-plugin-sdk" "$NEW_VERSION" "$NIX_HASH" "$DOWNLOAD_URL"
    '';
  };

  meta = {
    description = "Atlassian Plugin SDK";
    homepage = "https://developer.atlassian.com/server/framework/atlassian-sdk/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pathob ];
    platforms = lib.platforms.linux;
    mainProgram = "atlas-mvn";
  };
})
