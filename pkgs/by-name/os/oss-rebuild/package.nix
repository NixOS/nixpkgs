{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "oss-rebuild";
  version = "0-unstable-2025-07-22";

  src = fetchFromGitHub {
    owner = "google";
    repo = "oss-rebuild";
    rev = "6f57c474a8faf3012204792af8ef5d8b6fae2fd1";
    hash = "sha256-H8HkhQcRt6C+lxoMVLzRfhv60Mq8TAf83ctOBRbx4p0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-H6ZMop3tXwpzvjoLWAaovP8UHSYLLFxvSz2jhz8tj/g=";

  subPackages = [
    "cmd/oss-rebuild"
    "cmd/proxy"
    "cmd/stabilize"
    "cmd/timewarp"
    # There are other tools in available, but without documentation.
  ];

  ldflags = [ "-s" ];

  env.CGO_ENABLED = 0;

  meta = {
    description = "Securing open-source package ecosystems by originating, validating, and augmenting build attestations";
    longDescription = ''
      OSS Rebuild aims to apply reproducible build concepts at low-cost and high-scale for open-source package ecosystems.

      Rebuilds are derived by analyzing the published metadata and artifacts and are evaluated against the upstream package
      versions. When successful, build attestations are published for the upstream artifacts, verifying the integrity of
      the upstream artifact and eliminating many possible sources of compromise.

      [`oss-rebuild`](https://github.com/google/oss-rebuild?tab=readme-ov-file#usage) CLI tool provides access to OSS Rebuild
      data.

      [`proxy`](https://github.com/google/oss-rebuild/blob/main/cmd/proxy/README.md) is a transparent HTTP(S) proxy that
      intercepts and records network activity. It's primarily used within OSS Rebuild to monitor network interactions during
      the build process, helping to passively enumerate remote dependencies and to identify suspect build behavior.

      [`stabilize`](https://github.com/google/oss-rebuild/blob/main/cmd/stabilize/README.md) is a command-line tool that
      removes non-deterministic metadata from software packages to facilitate functional comparison of artifacts.

      [`timewarp`](https://github.com/google/oss-rebuild/blob/main/cmd/timewarp/README.md) is a registry-fronting HTTP
      service that filters returned content by time. This tool allows you to transparently adjust the data returned to
      package manager clients to reflect the state of a registry at a given point in time (especially useful for reproducing
      prior builds).
    '';
    homepage = "https://github.com/google/oss-rebuild";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "oss-rebuild";
  };
})
