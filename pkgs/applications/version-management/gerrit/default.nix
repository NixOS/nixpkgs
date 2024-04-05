{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gerrit";
  version = "3.9.2";

  src = fetchurl {
    url = "https://gerrit-releases.storage.googleapis.com/gerrit-${version}.war";
    hash = "sha256-KsuuwFKdpXHDVAZZ2JiX781mgqDQyyEILo4lmNn+8YE=";
  };

  buildCommand = ''
    mkdir -p "$out"/webapps/
    ln -s ${src} "$out"/webapps/gerrit-${version}.war
  '';

  passthru = {
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
  };

  meta = with lib; {
    homepage = "https://www.gerritcodereview.com/index.md";
    license = licenses.asl20;
    description = "A web based code review and repository management for the git version control system";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ flokli zimbatm ];
    platforms = platforms.unix;
  };
}
