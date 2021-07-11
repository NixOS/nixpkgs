{ version ? "release", lib, fetchFromGitHub, buildGo115Module, coreutils }:

let

  versionSpec = rec {
    unstable = rec {
      pname = "bee-unstable";
      version = "2021-06-21";
      rev = "0c04cf56b0f7ce7d76be783d2484a5b824964b54";
      goVersionString = "g" + builtins.substring 0 9 rev;     # this seems to be some kind of standard of git describe --tags HEAD
      hash = "sha256:14j7s1k14k14yczyz08iv0nrfw82lbb0anxc756m1vfa15qa6kx2";
      vendorSha256 = "sha256:1pvl88br6j26l4smm4kvi122127mna0r45hkg4ykpn902j2vwydd";
    };
    release = rec {
      pname = "bee";
      version = "1.0.0";
      rev = "v${version}";
      goCommitTime = 1624280569;   # to produce it: git show -s --format=%ct ${rev}
      hash = "sha256:14yk5z4lnz7mw875m6y0j43frl3gy8iy43i775z1a3hpycfvqnm9";
      vendorSha256 = "sha256:1pvl88br6j26l4smm4kvi122127mna0r45hkg4ykpn902j2vwydd";
    };
  }.${version};

in

buildGo115Module {
  inherit (versionSpec) pname version vendorSha256;

  src = fetchFromGitHub {
    owner = "ethersphere";
    repo = "bee";
    inherit (versionSpec) rev hash;
  };

  # NOTE running the tests only works using buildGo115Module and up, due to the -ldflags below
  doCheck = false;

  nativeBuildInputs = [ coreutils ];

  subPackages = [ "cmd/bee" ];

  # no symbol table, no debug info, and pass the commit for the version string
  buildFlags = "-ldflags -s -ldflags -w -ldflags"
               + lib.optionalString ( lib.hasAttr "goVersionString" versionSpec)
                 " -X=github.com/ethersphere/bee.commit=${versionSpec.goVersionString}"
               + lib.optionalString ( lib.hasAttr "goCommitTime" versionSpec)
                 " -X=github.com/ethersphere/bee.commitTime=${toString versionSpec.goCommitTime}";

  # Mimic the bee Makefile: without disabling CGO, two (transitive and
  # unused) dependencies would fail to compile.
  preBuild = ''
    export CGO_ENABLED=0
  '';

  # NOTE upstream bee-get-addr is dealing with hardwired paths,
  # therefore we can't use it, and we need to provide our own from the
  # service.

  # NOTE we don't package the upstream bee.service file because we
  # generate multiple service instances.

  meta = with lib; {
    homepage = "https://swarm.ethereum.org/";
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
