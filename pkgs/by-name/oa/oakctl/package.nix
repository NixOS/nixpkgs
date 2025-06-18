{
  lib,
  stdenv,
  fetchurl,
  libgcc,
  autoPatchelfHook,
  testers,
  oakctl,
}:

let
  version = "0.2.12";

  # Note: Extracted from install script
  # https://oakctl-releases.luxonis.com/oakctl-installer.sh
  sources = {
    x86_64-linux = fetchurl {
      url = "https://oakctl-releases.luxonis.com/data/${version}/linux_x86_64/oakctl";
      hash = "sha256-HCnFD0LD6sQp9k3SP2g4svjA5/kLvfrnN+IwiuMWGCY=";
    };
    aarch64-linux = fetchurl {
      url = "https://oakctl-releases.luxonis.com/data/${version}/linux_aarch64/oakctl";
      hash = "sha256-1oJQs57/tW3rsMM+LAuKiBUf1aKOKFoPQAMcVUfXqlE=";
    };
    aarch64-darwin = fetchurl {
      url = "https://oakctl-releases.luxonis.com/data/${version}/darwin_arm64/oakctl";
      hash = "sha256-arS2qfd/Z/ZCNWAKD9bc2PMwkhVtO5WViTibMST7zd8=";
    };
    x86_64-darwin = fetchurl {
      url = "https://oakctl-releases.luxonis.com/data/${version}/darwin_x86_64/oakctl";
      hash = "sha256-yyvDQbFEtlB8xmdbxquy22wAIUcCSVchP/AuSpi4TAU=";
    };
  };

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "oakctl";
  inherit version src;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  passthru.tests.version = testers.testVersion {
    command = "HOME=$TMPDIR oakctl version";
    package = oakctl;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libgcc ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D -m 0755 $src $out/bin/oakctl

    runHook postInstall
  '';

  # Note: The command 'oakctl self-update' won't work as the binary is located in the nix/store
  meta = {
    description = "Tool to interact with Luxonis OAK4 cameras";
    homepage = "https://rvc4.docs.luxonis.com/software/tools/oakctl";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "oakctl";
    maintainers = with lib.maintainers; [ phodina ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
