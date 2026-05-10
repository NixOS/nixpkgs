{
  lib,
  stdenvNoCC,
  fetchurl,
  cpio,
  xar,
  writeScript,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arq";
  version = "7.38.1";

  src = fetchurl {
    url = "https://www.arqbackup.com/download/arqbackup/Arq${finalAttrs.version}.pkg";
    hash = "sha256-RzG1eQybZxXbgWVkeCdIkEE6qaxzDIZ0kaR35sYUv0o=";
  };

  nativeBuildInputs = [
    cpio
    xar
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf $src
    zcat client.pkg/Payload | cpio -i

    runHook postUnpack
  '';

  installPhase = ''
    mkdir -p $out
    cp -R Applications $out
  '';

  dontBuild = true;

  # Arq is notarized
  dontFixup = true;

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl coreutils common-updater-scripts
    set -eu -o pipefail

    url="https://www.arqbackup.com/download/arqbackup/arq${lib.versions.major finalAttrs.version}_release_notes.html"
    release_notes="$(curl -sSL "$url")"
    version="$(echo "$release_notes" | grep -oP "Version\s+v?\K(\d+(?:\.\d+)+)" -m 1)"

    hash_base16="$(echo "$release_notes" | grep -oP "SHA(2-)?256\(\S+\)\= \K[0-9a-f]{64}" -m 1)"
    hash="$(nix-hash --to-sri --type sha256 "$hash_base16")"

    update-source-version ${finalAttrs.pname} "$version" "$hash" --print-changes
  '';

  meta = {
    changelog = "https://www.arqbackup.com/download/arqbackup/arq7_release_notes.html";
    description = "Multi-cloud backup software for your Macs";
    homepage = "https://www.arqbackup.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ lib.maintainers.Enzime ];
    platforms = lib.platforms.darwin;
  };
})
