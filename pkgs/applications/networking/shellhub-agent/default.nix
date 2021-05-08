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
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${version}";
    sha256 = "12g9067knppkci2acc4w9xcismgw2w1zd0f1swbzdnx8bxl3vg9i";
  };

  patches = [
    # Fix missing multierr package on go.mod
    ./fix-go-mod-deps.patch
  ];

  modRoot = "./agent";

  vendorSha256 = "0z5qvgmmrwwvhpmhjxdvgdfsd60a24q9ld68ggnkv36qln0gw7p4";

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
