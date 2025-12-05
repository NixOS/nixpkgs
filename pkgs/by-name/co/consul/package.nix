{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGo125Module rec {
  pname = "consul";
  version = "1.22.1";

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
    tag = "v${version}";
    hash = "sha256-WlaJtiFlfLpdMATWHPbMneCqKzNcIRJrlf5TlbZgH8U=";
  };

  # This corresponds to paths with package main - normally unneeded but consul
  # has a split module structure in one repo
  subPackages = [
    "."
    "connect/certgen"
  ];

  vendorHash = "sha256-QthyylbEkyfDPJIzIyL4u+d92MTZxIjZHBW39AZKmzo=";

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

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Tool for service discovery, monitoring and configuration";
    changelog = "https://github.com/hashicorp/consul/releases/tag/v${version}";
    homepage = "https://www.consul.io/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsl11;
    maintainers = with maintainers; [
      vdemeester
      nh2
      techknowlogick
    ];
    mainProgram = "consul";
  };
}
