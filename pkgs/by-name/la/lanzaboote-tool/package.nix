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
  uefi-stub ? pkgsCross."${stdenv.hostPlatform.qemuArch}-unknown-uefi".lanzaboote-uefi-stub,
}:

let
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
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set LANZABOOTE_STUB ${lib.getExe uefi-stub} \
      ;
  '';

  nativeCheckInputs = runtimeDeps;

  passthru = {
    lanzaboote-uefi-stub = uefi-stub;
    updateScript = nix-update-script { };
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Lanzaboote UEFI tooling for UEFI Secure Boot enablement on NixOS systems";
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
