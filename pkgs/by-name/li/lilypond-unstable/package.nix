{
  lib,
  fetchzip,
  lilypond,
  writeScript,
}:

lilypond.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "2.25.32";

    src = fetchzip {
      url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor finalAttrs.version}/lilypond-${finalAttrs.version}.tar.gz";
      hash = "sha256-j7Avb9WSy27yQCak3KV7OB24M+T76b/tLcLoINLSEbo=";
    };

    passthru.updateScript = writeScript "update-lilypond-unstable" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts curl
      version="$(curl -s 'https://gitlab.com/lilypond/lilypond/-/raw/master/VERSION' | grep 'VERSION_DEVEL=' | cut -d= -f2)"
      update-source-version lilypond-unstable "$version" \
         --file=pkgs/by-name/li/lilypond-unstable/package.nix
    '';
  }
)
