{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  openvmm,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nvx";
  version = "0-unstable-2026-10-04";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "nvx";
    tag = "v0.1.0-dev.9653b1e1419b";
    hash = "sha256-qctSGiirhXW50BwaMlzBlSgY3RC4BUhXPTW1tDgOLrM=";
  };

  nativeBuildInputs = [
    makeWrapper
    python3
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  patches = [
    ./openvmm-path.patch
  ];

  installPhase = ''
    runHook preInstall
    install --directory "$out/bin" "$out/share/nvx"
    install --mode=0755 scripts/nvx.py "$out/share/nvx/nvx.py"
    cp --recursive scripts/nvx_tools "$out/share/nvx/nvx_tools"
    makeWrapper "${lib.getExe python3}" "$out/bin/nvx" \
      --add-flags "$out/share/nvx/nvx.py" \
      --set PYTHONPATH "$out/share/nvx" \
      --prefix PATH : "${lib.makeBinPath [ openvmm ]}"
    runHook postInstall
  '';

  meta = {
    description = "Cross-platform micro-VM sandbox for agentic workloads";
    longDescription = ''
      NVX creates hardware-enforced, isolated micro-VM sandboxes for agentic
      workloads. It orchestrates OpenVMM to run untrusted code inside a
      lightweight virtual machine with KVM or MSHV as the hypervisor backend.
    '';
    homepage = "https://github.com/microsoft/nvx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sheeeng
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "nvx";
  };
})
