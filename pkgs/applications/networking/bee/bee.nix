{ version ? "release", lib, fetchFromGitHub, buildGoModule }:

let

  versionSpec = rec {
    unstable = rec {
      pname = "bee-unstable";
      version = "2021-01-30";
      rev = "824636a2c2629c329ab10275cef6a0b7395343ad";
      goVersionString = "g" + builtins.substring 0 7 rev;     # this seems to be some kind of standard of git describe...
      sha256 = "0ly1yqjq29arbak8lchdradf39l5bmxpbfir6ljjc7nyqdxz0sxg";
      vendorSha256 = "sha256-w5ZijaK8Adt1ZHPMmXqRWq0v0jdprRKRu03rePtZLXA=";
    };
    release = rec {
      pname = "bee";
      version = "0.5.0";
      rev = "refs/tags/v${version}";
      sha256 = "sha256-3Oy9RhgMPRFjUs3Dj8XUhAqoxx5BTi32OiK4Y8YEG2Q=";
      vendorSha256 = "sha256-w5ZijaK8Adt1ZHPMmXqRWq0v0jdprRKRu03rePtZLXA=";
    };
    "0.5.0" = release;
    "0.4.1" = rec {
      pname = "bee";
      version = "0.4.1";
      rev = "refs/tags/v${version}";
      sha256 = "1bmgbav52pcb5p7cgq9756512fzfqhjybyr0dv538plkqx47mpv7";
      vendorSha256 = "0j393va4jrg9q3wlc9mgkbpgnn2w2s3k2hcn8phzj8d5fl4n4v2h";
    };
  }.${version};

in

buildGoModule {
  inherit (versionSpec) pname version vendorSha256;

  src = fetchFromGitHub {
    owner = "ethersphere";
    repo = "bee";
    inherit (versionSpec) rev sha256;
  };

  subPackages = [ "cmd/bee" ];

  # no symbol table, no debug info, and pass the commit for the version string
  ldflags = lib.optionals ( lib.hasAttr "goVersionString" versionSpec)
    [ "-s" "-w" "-X=github.com/ethersphere/bee.commit=${versionSpec.goVersionString}" ];

  # Mimic the bee Makefile: without disabling CGO, two (transitive and
  # unused) dependencies would fail to compile.
  preBuild = ''
    export CGO_ENABLED=0
  '';

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    cp packaging/bee.service $out/lib/systemd/system/
    cp packaging/bee-get-addr $out/bin/
    chmod +x $out/bin/bee-get-addr
    patchShebangs $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/ethersphere/bee";
    description = "Ethereum Swarm Bee";
    longDescription = ''
      A decentralised storage and communication system for a sovereign digital society.

      Swarm is a system of peer-to-peer networked nodes that create a decentralised storage and communication service. The system is economically self-sustaining due to a built-in incentive system enforced through smart contracts on the Ethereum blockchain.

      Bee is a Swarm node implementation, written in Go.
    '';
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ attila-lendvai ];
  };
}
