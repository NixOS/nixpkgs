{
  fetchFromGitHub,
  binutils-unwrapped,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  pkgsCross,
  rustPlatform,
  sbsigntool,
  stdenv,
  systemd,
}:

let
  stub = pkgsCross."${stdenv.hostPlatform.qemuArch}-unknown-uefi".lanzaboote-uefi-stub;

  runtimeDeps = [
    binutils-unwrapped
    sbsigntool
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lanzaboote-tool";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "lanzaboote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sr4Kfp6yaXUeyKL6n0Y8/ElcR3momIRC20HFc+LF22s=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust/tool";
  cargoHash = "sha256-ljBPmdpgsG00OuOfXxXIswUpDPcdc/kPUzrAQlHJNS4=";

  env.TEST_SYSTEMD = systemd;
  doCheck = lib.meta.availableOn stdenv.hostPlatform systemd;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    # Clean PATH to only contain what we need to do objcopy
    makeWrapper $out/bin/lzbt-systemd $out/bin/lzbt \
      --set PATH ${lib.makeBinPath runtimeDeps} \
      --set LANZABOOTE_STUB ${lib.getExe stub}
  '';

  nativeCheckInputs = runtimeDeps;

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Lanzaboote UEFI tooling for SecureBoot enablement on NixOS systems";
    homepage = "https://github.com/nix-community/lanzaboote";
    license = lib.licenses.gpl3Only;
    mainProgram = "lzbt";
    maintainers = with lib.maintainers; [
      raitobezarius
      ThinkChaos
    ];
    # Others might work but are untested ATM
    platforms = [
      "x86_64-linux"
    ];
  };
})
