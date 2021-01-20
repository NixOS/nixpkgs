{ lib, stdenv
, buildGoModule
, fetchFromGitHub
, genericUpdater
, common-updater-scripts
}:

buildGoModule rec {
  pname = "shellhub-agent";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${version}";
    sha256 = "0cd41ing1pcf1bdaaq00w5h7lih5j2kcaa0m41g3ikm3vd1w5qna";
  };

  modRoot = "./agent";

  vendorSha256 = "19gsfhh6idqysdxhpq45sq35gw19adz9lp83krjlhzj1vqm59qma";

  buildFlagsArray = [ "-ldflags=-s -w -X main.AgentVersion=v${version}" ];

  passthru = {
    updateScript = genericUpdater {
      inherit pname version;
      versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };
  };

  meta = with lib; {
    description =
      "Enables easy access any Linux device behind firewall and NAT";
    longDescription = ''
      ShellHub is a modern SSH server for remotely accessing Linux devices via
      command line (using any SSH client) or web-based user interface, designed
      as an alternative to _sshd_. Think ShellHub as centralized SSH for the the
      edge and cloud computing.
    '';
    homepage = "https://shellhub.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
    platforms = platforms.linux;
  };
}
