{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule rec {
  pname = "consul";
  version = "1.18.4";

  # Note: Currently only release tags are supported, because they have the Consul UI
  # vendored. See
  #   https://github.com/NixOS/nixpkgs/pull/48714#issuecomment-433454834
  # If you want to use a non-release commit as `src`, you probably want to improve
  # this derivation so that it can build the UI's JavaScript from source.
  # See https://github.com/NixOS/nixpkgs/pull/49082 for something like that.
  # Or, if you want to patch something that doesn't touch the UI, you may want
  # to apply your changes as patches on top of a release commit.
  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "refs/tags/ent-changelog-${version}";
    hash = "sha256-LoJFRVzhPBAhVfCuApCw3N1ULQ1OO2oAcKNG+1GLPZw=";
  };

  # This corresponds to paths with package main - normally unneeded but consul
  # has a split module structure in one repo
  subPackages = [
    "."
    "connect/certgen"
  ];

  vendorHash = "sha256-hdPeqYnTUO+WjVt1a9NIwvKOwF7QcvCqaA2mCdLzEm8=";

  postPatch = ''
    # override dev version from release tag
    echo ${version} > version/VERSION
  '';

  doCheck = false;

  ldflags = [
    "-X github.com/hashicorp/consul/version.GitDescribe=v${version}"
    "-X github.com/hashicorp/consul/version.Version=${version}"
    "-X github.com/hashicorp/consul/version.VersionPrerelease="
  ];

  passthru = {
    tests = {
      inherit (nixosTests) consul;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "-vr"
        "ent-changelog-(1.18.*)"
      ];
    };
  };

  meta = with lib; {
    description = "Tool for service discovery, monitoring and configuration";
    changelog = "https://github.com/hashicorp/consul/releases/tag/v${version}";
    homepage = "https://www.consul.io/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsl11;
    maintainers = with maintainers; [
      adamcstephens
      pradeepchhetri
      vdemeester
      nh2
      techknowlogick
    ];
    mainProgram = "consul";
  };
}
