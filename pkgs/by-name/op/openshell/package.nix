{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
}:

let
  repo = "NVIDIA/OpenShell";
  version = "0.0.76";
  baseUrl = "https://github.com/${repo}/releases/download/v${version}";

  versionsData = builtins.fromJSON (builtins.readFile ./versions.json);
  versionData = versionsData.${version} or (throw "No checksums found for version ${version}");

  checksums = {
    main = versionData.main or (throw "No main checksums for version ${version}");
    gateway = versionData.gateway or { };
    sandbox = versionData.sandbox or { };
    driver = versionData.driver or (throw "No driver checksums for version ${version}");
  };

  # ── Architecture / platform mapping ────────────────────────────────────
  archMap = {
    x86_64-linux = "x86_64";
    aarch64-linux = "aarch64";
    aarch64-darwin = "aarch64";
  };

  platformMap = {
    x86_64-linux = "x86_64-unknown-linux-musl";
    aarch64-linux = "aarch64-unknown-linux-musl";
    aarch64-darwin = "aarch64-apple-darwin";
  };

  platformGnuMap = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
  };

  # ── Asset name builders ────────────────────────────────────────────────
  mainAsset = system: "openshell-${platformMap.${system}}.tar.gz";
  gatewayAsset = system: "openshell-gateway-${platformGnuMap.${system}}.tar.gz";
  sandboxAsset = system: "openshell-sandbox-${platformGnuMap.${system}}.tar.gz";
  driverAsset =
    system:
    "openshell-driver-vm-${
      if system == "aarch64-darwin" then
        "aarch64-apple-darwin"
      else
        "${archMap.${system}}-unknown-linux-gnu"
    }.tar.gz";

  # ── Fetch helper ───────────────────────────────────────────────────────
  fetchTarball =
    system: name: url: sha256:
    fetchurl {
      inherit url sha256;
      name = "openshell-${name}-v${version}";
    };

  # ── Install script per platform ────────────────────────────────────────
  installScript =
    system:
    let
      mainTarball = fetchTarball system "main" "${baseUrl}/${mainAsset system}" checksums.main.${system};
      driverTarball =
        fetchTarball system "driver" "${baseUrl}/${driverAsset system}"
          checksums.driver.${system};
      gatewayTarball =
        fetchTarball system "gateway" "${baseUrl}/${gatewayAsset system}"
          checksums.gateway.${system};
      sandboxTarball =
        fetchTarball system "sandbox" "${baseUrl}/${sandboxAsset system}"
          checksums.sandbox.${system};
      isLinux = lib.any (p: system == p) [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    ''
      mkdir -p $out/bin

      # Extract main CLI binary
      tar xzf "${mainTarball}" -C $out/bin

      # Extract gateway binary (Linux only)
      ${lib.optionalString isLinux ''
        tar xzf "${gatewayTarball}" -C $out/bin
      ''}

      # Extract sandbox binary (Linux only)
      ${lib.optionalString isLinux ''
        tar xzf "${sandboxTarball}" -C $out/bin
      ''}

      # Extract driver-vm binary
      tar xzf "${driverTarball}" -C $out/bin

      # Ensure all binaries are executable
      chmod +x $out/bin/openshell
      chmod +x $out/bin/openshell-gateway
      chmod +x $out/bin/openshell-sandbox
      chmod +x $out/bin/openshell-driver-vm
    '';

in
stdenv.mkDerivation {
  pname = "openshell";
  inherit version;
  strictDeps = true;

  # No source needed — everything is fetched via fetchurl above.
  # We use a dummy file and override unpackPhase to skip extraction.
  src = builtins.toFile "noop" "";
  dontUnpack = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = installScript stdenv.hostPlatform.system;

  dontStrip = true;

  meta = {
    changelog = "https://github.com/${repo}/releases/tag/v${version}";
    description = "Safe, private runtime for autonomous AI agents";
    longDescription = ''
      NVIDIA OpenShell is an open source runtime to build and deploy autonomous,
      self-evolving agents more safely. OpenShell sits between your agent and
      your infrastructure to govern how the agent executes, what the agent can
      see and do, and where inference goes. It enables claws to run in isolated
      sandboxes, with fine-grained control over privacy and security.
    '';
    homepage = "https://docs.nvidia.com/openshell/index.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      wishstudio
      bornav
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "openshell";
  };
}
