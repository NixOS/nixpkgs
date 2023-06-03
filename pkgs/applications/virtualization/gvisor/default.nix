{ lib
, buildGoModule
, fetchFromGitHub
, iproute2
, iptables
, makeWrapper
, procps
}:

buildGoModule rec {
  pname = "gvisor";
  version = "20230529.0";

  # gvisor provides a synthetic go branch (https://github.com/google/gvisor/tree/go)
  # that can be used to build gvisor without bazel.
  #
  # For updates, you should stick to the commits labeled "Merge release-** (automated)"
  # Make sure to check that the tagged commit for a release aligns with the version in
  # the message for good measure; e.g. the commit
  #
  #     142d38d770a07291877dc0d50b88b719dbef76dc is "Merge release-20230522.0-11-g919cfd12b (automated)"
  #
  # on the 'go' branch. But the mentioned commit, 919cfd12b..., is actually tagged as release-20230529.0
  #
  #    https://github.com/google/gvisor/releases/tag/release-202329.0
  #
  # Presumably this is a result of the release process. Handle with care.

  src = fetchFromGitHub {
    owner = "google";
    repo = "gvisor";
    rev = "142d38d770a07291877dc0d50b88b719dbef76dc";
    hash = "sha256-Ukcjlz/6iUmDAUpQpIVfZHKbwK90Mt6fukcFaw64hQI=";
  };

  vendorHash = "sha256-COr47mZ4tsbzMjkv63l+fexo0RL5lrBXeewak9CuZVk=";

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  subPackages = [ "runsc" "shim" ];

  postInstall = ''
    # Needed for the 'runsc do' subcommand
    wrapProgram $out/bin/runsc \
      --prefix PATH : ${lib.makeBinPath [ iproute2 iptables procps ]}
    mv $out/bin/shim $out/bin/containerd-shim-runsc-v1
  '';

  meta = with lib; {
    description = "Application Kernel for Containers";
    homepage = "https://github.com/google/gvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ andrew-d gpl ];
    platforms = [ "x86_64-linux" ];
  };
}
