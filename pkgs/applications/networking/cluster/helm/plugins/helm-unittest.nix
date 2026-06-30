{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

let
  version = "1.1.0";
in
buildGoModule {
  pname = "helm-unittest";
  inherit version;

  src = fetchFromGitHub {
    owner = "helm-unittest";
    repo = "helm-unittest";
    tag = "v${version}";
    hash = "sha256-tSagZzAEaJRNZwflrqoyuIMWmt3oCsyHPHwctNTrtVM=";
  };

  vendorHash = "sha256-LZOvss6wiZZi5USuXfivqtt69dTKzEmm7lM2LUDACfY=";

  postPatch = ''
    # Remove the install and upgrade hooks.
    sed -i '/^platformHooks:[[:space:]]*$/,/^[^[:space:]]/d' plugin.yaml
    # Remove the per-platform commands
    sed -i '/^platformCommand:[[:space:]]*$/,/^[^[:space:]]/d' plugin.yaml
    # Add a simple runtime config
    cat <<'EOF' >> ./plugin.yaml
    platformCommand:
      - command: "''$HELM_PLUGIN_DIR/helm-unittest"
    EOF
  '';

  subPackages = [ "cmd/helm-unittest" ];

  installPhase = ''
    runHook preInstall

    install -dm755 "$out/helm-unittest"
    install -m755 -Dt "$out/helm-unittest" "$GOPATH/bin/helm-unittest"
    install -m644 -Dt "$out/helm-unittest" ./plugin.yaml

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "BDD styled unit test framework for Kubernetes Helm charts as a Helm plugin";
    homepage = "https://github.com/helm-unittest/helm-unittest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      booxter
      yurrriq
    ];
  };
}
