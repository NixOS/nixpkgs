{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, nix-update-script
, stdenv
, systemd
}:
buildGoModule rec {
  pname = "netclient";
  version = "unstable-2024-01-26";

  src = fetchFromGitHub {
    # TODO: switch to upstream after https://github.com/gravitl/netclient/pull/682
    #owner = "gravitl";
    owner = "nazarewk";
    repo = "netclient";
    rev = "7262296d65f1e129f1475782c453bcf10f5f60d7";
    hash = "sha256-veh+k2WxfOqVFrUgyDOTuxI7Q87m8EH6LhrF0ZQr/tA=";
  };
  vendorHash = "sha256-w7D79uUnfKg3rK9s9XSHWCtA/RbN9X9jc1eaOzCvVJk=";

  subPackages = [
    "."
    /* TODO: to package "gui":
        1. create a separate package because it pulls in graphical dependencies unnecessary on servers
           old package is a good starting point https://github.com/NixOS/nixpkgs/blob/1c4593f3519b83840087729589abf6a45b6803f6/pkgs/by-name/ne/netclient/package.nix
        2. be sure to rename `gui` binary to `netclient-gui` or something else more appropriate
    */
    # "gui"
  ];
  CGO_ENABLED = false;
  hardeningEnabled = [ "pie" ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postInstall = ''
    wrapProgram "$out/bin/netclient" \
      --set NETCLIENT_AUTO_UPDATE disabled \
      --set NETCLIENT_INIT_TYPE '${lib.optionalString (lib.meta.availableOn stdenv.hostPlatform systemd) "systemd"}'

    installShellCompletion --cmd netclient \
      --bash <($out/bin/netclient completion bash) \
      --fish <($out/bin/netclient completion fish) \
      --zsh <($out/bin/netclient completion zsh)
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=fix-sso" ]; };
  meta = {
    description = "Automated WireGuard® Management Client";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netclient/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wexder nazarewk ];
    mainProgram = "netclient";
  };
}
