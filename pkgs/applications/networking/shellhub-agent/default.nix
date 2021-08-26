{ lib
, buildGoModule
, fetchFromGitHub
, genericUpdater
, common-updater-scripts
, makeWrapper
, openssh
}:

buildGoModule rec {
  pname = "shellhub-agent";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${version}";
    sha256 = "02ka7acynkwkml2pavlv4j5vkm6x5aq5sfxgydv26qzs39f1wdgc";
  };

  modRoot = "./agent";

  vendorSha256 = "18z3vwcwkyj6hcvl35qmj034237h9l18dvcbx1hxry7qdwv807c9";

  buildFlagsArray = [ "-ldflags=-s -w -X main.AgentVersion=v${version}" ];

  passthru = {
    updateScript = genericUpdater {
      inherit pname version;
      versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/agent --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

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
