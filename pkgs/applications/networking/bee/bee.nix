{ version ? "release", lib, fetchFromGitHub, buildGo115Module, coreutils }:

let

  versionSpec = rec {
    unstable = rec {
      pname = "bee-unstable";
      version = "2021-06-21";
      rev = "0c04cf56b0f7ce7d76be783d2484a5b824964b54";
      goVersionString = "g" + builtins.substring 0 9 rev;     # this seems to be some kind of standard of git describe --tags HEAD
      hash = "sha256:14j7s1k14k14yczyz08iv0nrfw82lbb0anxc756m1vfa15qa6kx2";
      vendorSha256 = "sha256:09ym5rjlvhjpa2yif2ksjlj540ij2s62y802c5956csgwa5a2gnz";
    };
    release = rec {
      pname = "bee";
      version = "1.1.0-rc1";
      rev = "v${version}";
      goCommitTime = 1628004442;   # to produce it: git show -s --format=%ct ${rev}
      hash = "sha256:0csp875z5awx877ljpf86wjvwp40ys3004w8rlk83r8psz99pzz0";
      vendorSha256 = "sha256:09ym5rjlvhjpa2yif2ksjlj540ij2s62y802c5956csgwa5a2gnz";
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

  # no symbol table, no debug info, and pass the commit info (for the version string and the outdated warning)
  buildFlags = "-ldflags -s -ldflags -w"
               + lib.optionalString (lib.hasAttr "goVersionString" versionSpec)
                 " -ldflags -X=github.com/ethersphere/bee.commitHash=${versionSpec.goVersionString}"
               + lib.optionalString (lib.hasAttr "goCommitTime" versionSpec)
                 " -ldflags -X=github.com/ethersphere/bee.commitTime=${toString versionSpec.goCommitTime}";

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
