{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
, nix-update-script
, withServer ? true
, withCLI ? false
, isPro ? false
, ...
}:
buildGoModule rec {
  pname = lib.concatStringsSep "-" (
    lib.optional withServer "netmaker"
    ++ lib.optional (!withServer && withCLI) "nmctl"
    ++ lib.optional isPro "pro"
  );

  version = "unstable-2024-01-26";

  src = fetchFromGitHub {
    # TODO: switch to upstream (gravitl) after https://github.com/gravitl/netmaker/pull/2785
    owner = "nazarewk";
    repo = "netmaker";
    rev = "36ffc395eaff2c6e66fc6e17034329292541ca52";
    hash = "sha256-P19fGDMFKjiR5LP1kQitTVMLKYiPs0z3ICZaIFfgRzQ=";
    postFetch = lib.optionalString (!isPro) ''
      # $out/pro holds propertiary licensed code and main_ee.go uses it with correct build flag.
      rm -r $out/pro
      rm $out/main_ee.go
    '';
  };
  vendorHash = "sha256-t7g6Tozq/QLq0/5bpXNDCJrOPTjMlvcDUaD6EGqII3Y=";

  subPackages = lib.optional withServer "."
    ++ lib.optional withCLI "cli";

  CGO_ENABLED = true;
  tags = lib.optional isPro "ee";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString withCLI ''
    mv $out/bin/{cli,nmctl}

    installShellCompletion --cmd nmctl \
      --bash <($out/bin/nmctl completion bash) \
      --fish <($out/bin/nmctl completion fish) \
      --zsh <($out/bin/nmctl completion zsh)
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=fix-sso" ]; };
  meta = {
    description = "WireGuard automation from homelab to enterprise - ${if isPro then "Professional" else "Community"} Edition";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netmaker/-/releases/v${version}";
    license = if isPro then lib.licenses.unfree else lib.licenses.asl20;
    maintainers = with lib.maintainers; [ urandom qjoly nazarewk ];
    mainProgram = if withCLI && !withServer then "nmctl" else "netmaker";
  };
}
