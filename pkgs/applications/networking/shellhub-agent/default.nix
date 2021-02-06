{ lib
, buildGoModule
, fetchFromGitHub
, genericUpdater
, common-updater-scripts
}:

buildGoModule rec {
  pname = "shellhub-agent";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${version}";
    sha256 = "1g3sjkc6p9w3mm7lnr513zwjh7y945hx311b6g068q2lywisqf0x";
  };

  modRoot = "./agent";

  vendorSha256 = "1l8x9cvisjb8smnsg91v04j1vvawpjzp0lcq0ahw8slz8rfdm80c";

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
