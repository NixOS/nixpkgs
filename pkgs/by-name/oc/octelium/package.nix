{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "octelium";
  version = "0.27.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "octelium";
    repo = "octelium";
    tag = "v${version}";
    hash = "sha256-O2jgGKuE5Y0WcsreZrgTNkWw94CEK9EfOrND7pwjqBw=";
  };

  # Use proxyVendor for Go workspace support
  proxyVendor = true;

  vendorHash = "sha256-7CmpyH8I20AgUeRk8q1Z1HR43I0BTWgQEefDzZ6hgzk=";

  # Build all three CLI tools
  subPackages = [
    "client/octelium"
    "client/octeliumctl"
    "client/octops"
  ];

  # Set ldflags to match the Makefile build flags
  ldflags =
    let
      ldflags_path = "github.com/octelium/octelium/pkg/utils/ldflags";
    in
    [
      "-X ${ldflags_path}.GitCommit=${version}"
      "-X ${ldflags_path}.GitTag=v${version}"
      "-X ${ldflags_path}.GitBranch=main"
      "-X ${ldflags_path}.SemVer=v${version}"
      "-X ${ldflags_path}.ImageRegistry=ghcr.io"
      "-X ${ldflags_path}.ImageRegistryPrefix=octelium"
    ];

  meta = {
    description = "Next-gen FOSS self-hosted unified zero trust secure access platform";
    longDescription = ''
      Octelium is a free and open source, self-hosted, unified zero trust secure
      access platform that can operate as a modern zero-config remote access VPN,
      a comprehensive Zero Trust Network Access (ZTNA)/BeyondCorp platform, an
      ngrok/Cloudflare Tunnel alternative, an API gateway, an AI/LLM gateway, a
      scalable infrastructure for MCP gateways and A2A architectures/meshes, a
      PaaS-like platform, and a homelab infrastructure.

      This package includes three CLI tools:
      - octelium: Used by all Users to connect to the Cluster and access its Services
      - octeliumctl: Used by Cluster managers to manage the Cluster's resources
      - octops: Used to install, upgrade and uninstall Clusters
    '';
    homepage = "https://github.com/octelium/octelium";
    changelog = "https://github.com/octelium/octelium/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20 # Client components
      agpl3Only # Cluster components (not built here)
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "octelium";
  };
}
