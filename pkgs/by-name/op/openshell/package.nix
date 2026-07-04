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

  # ── Checksums ──────────────────────────────────────────────────────────
  # Update these from the release checksum files:
  #   openshell-checksums-sha256.txt
  #   openshell-gateway-checksums-sha256.txt
  #   openshell-sandbox-checksums-sha256.txt
  checksums = {
    main = {
      x86_64-linux = "dacdc2a0dcc31b5006276b2d810399bd8482f87fecef47f2fee882e280ae11c4";
      aarch64-linux = "174b2b8291b8c2825a4fbc6c9c6e9cf7f428ec566fcab5f34d4eca78012e052d";
      aarch64-darwin = "f4a95d117569f515363fb61337d108cde4cae84e0f6b32bfc8821796d8979e3b";
    };
    gateway = {
      x86_64-linux = "9de752d60bc3b2a5076c8378794f5921769708b27f2a026f6d9314379039a73d";
      aarch64-linux = "e6d11b6dc3396bd97eaebbfd5a362573d0618fc24c64113e9e5ae6b7ab7e8e56";
    };
    sandbox = {
      x86_64-linux = "fe199994d94e19bebe055168446ad674d8396465aa2e880aaa8ecf5c3db0a24c";
      aarch64-linux = "c678fd85c7671ee9a2be1b1b74e9284e6f8b545b735db63b4747f49a5d204e11";
    };
    driver = {
      x86_64-linux = "7be64f2009c2989b48a5ba515fec99f6bdd781a207303bf2025fb310807bf6e0";
      aarch64-linux = "e3ff330edbeef1dc89d49c92548ba35b4599846a76ce6c2fbae1b6d2da4dfbd5";
      aarch64-darwin = "c3326a40f11353d2cb908b8f0db1ffdf67804c66ae549405bfb96965446a5e56";
    };
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
    homepage = "https://docs.nvidia.com/openshell/index.html";
    longDescription = ''
      NVIDIA OpenShell is an open source runtime to build and deploy autonomous,
      self-evolving agents more safely. OpenShell sits between your agent and
      your infrastructure to govern how the agent executes, what the agent can
      see and do, and where inference goes. It enables claws to run in isolated
      sandboxes, with fine-grained control over privacy and security.
    '';
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
