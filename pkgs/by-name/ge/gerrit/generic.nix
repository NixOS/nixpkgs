{
  lib,
  stdenvNoCC,
  gitUpdater,
  nixosTests,
  fetchurl,
  version,
  hash,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gerrit";
  inherit version;

  src = fetchurl {
    url = "https://gerrit-releases.storage.googleapis.com/gerrit-${finalAttrs.version}.war";
    inherit hash;
  };

  buildCommand = ''
    mkdir -p "$out"/webapps/
    ln -s ${finalAttrs.src} "$out"/webapps/gerrit-${finalAttrs.version}.war
  '';

  passthru = {
    updateScript = gitUpdater {
      url = "https://gerrit.googlesource.com/gerrit";
      rev-prefix = "v";
      allowedVersions = "^[0-9\\.]+$";
    };
    # A list of plugins that are part of the gerrit.war file.
    # Use `java -jar gerrit.war ls | grep plugins/` to generate that list.
    plugins = [
      "codemirror-editor"
      "commit-message-length-validator"
      "delete-project"
      "download-commands"
      "gitiles"
      "hooks"
      "plugin-manager"
      "replication"
      "reviewnotes"
      "singleusergroup"
      "webhooks"
    ];
    tests = {
      inherit (nixosTests) gerrit;
    };
  };

  meta = {
    homepage = "https://www.gerritcodereview.com/index.md";
    license = lib.licenses.asl20;
    description = "Web based code review and repository management for the git version control system";
    changelog = "https://www.gerritcodereview.com/${lib.versions.majorMinor finalAttrs.version}.html";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [
      flokli
      zimbatm
      felixsinger
    ];
    platforms = lib.platforms.unix;
  };
})
