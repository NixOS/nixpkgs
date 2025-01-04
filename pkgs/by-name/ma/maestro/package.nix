{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  jre_headless,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maestro";
  version = "1.39.2";

  src = fetchurl {
    url = "https://github.com/mobile-dev-inc/maestro/releases/download/cli-${finalAttrs.version}/maestro.zip";
    hash = "sha256-yX9ZtfWLg2OnsDqYH9jSW6elB+snmUUY5hWjO2Bw1sA=";
  };

  dontUnpack = true;
  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  installPhase = ''
    mkdir $out
    unzip $src -d $out
    mv $out/maestro/* $out
    rm -rf $out/maestro
  '';

  postFixup = ''
    wrapProgram $out/bin/maestro --prefix PATH : "${lib.makeBinPath [ jre_headless ]}"
  '';

  passthru.updateScript = writeScript "update-maestro" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    set -o errexit -o nounset -o pipefail

    NEW_VERSION=$(curl --silent https://api.github.com/repos/mobile-dev-inc/maestro/releases | jq 'first(.[].tag_name | ltrimstr("cli-") | select(contains("dev.") | not))' --raw-output)

    update-source-version "maestro" "$NEW_VERSION" --print-changes
  '';

  meta = with lib; {
    description = "Mobile UI Automation tool";
    homepage = "https://maestro.mobile.dev/";
    license = licenses.asl20;
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    changelog = "https://github.com/mobile-dev-inc/maestro/blob/main/CHANGELOG.md";
    maintainers = with maintainers; [ SubhrajyotiSen ];
    mainProgram = "maestro";
  };
})
