{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gerrit";
  version = "3.1.2";

  src = fetchurl {
    url = "https://gerrit-releases.storage.googleapis.com/gerrit-${version}.war";
    sha256 = "01hak4gqaqn40a0qvmg8a89ai3ndnjls5v64m8awig8j1yysz5vl";
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

  meta = with stdenv.lib; {
    homepage = "https://www.gerritcodereview.com/index.md";
    license = licenses.asl20;
    description = "A web based code review and repository management for the git version control system";
    maintainers = with maintainers; [ jammerful ];
    platforms = platforms.unix;
  };
}
