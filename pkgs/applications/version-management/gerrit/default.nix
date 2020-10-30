{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gerrit";
  version = "3.2.3";

  src = fetchurl {
    url = "https://gerrit-releases.storage.googleapis.com/gerrit-${version}.war";
    sha256 = "0hdxbn5qqqjzpqfcydz33nc351zanxp0j2k0ivizx4dn40fnavd7";
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
    maintainers = with maintainers; [ flokli jammerful zimbatm ];
    platforms = platforms.unix;
  };
}
