{
  lib,
  mkHyprlandPlugin,
  hyprland,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprfocus";
  version = "0-unstable-2024-11-09";

  src = fetchFromGitHub {
    owner = "pyt0xic";
    repo = "hyprfocus";
    rev = "bead5b77d80f222c006d1a6c6f44ee8b02021d73";
    hash = "sha256-qIl7opF7fA1ZmC91TGQ7D12tB7kHc6Sn9DrfUN6sbBY=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/pyt0xic/hyprfocus/commit/e7d9ee3c470b194fe16179ff2f16fc4233e928ef.patch";
      hash = "sha256-iETrtvoIZfcaD3TcKIIwFL8Rua0dFEqboml9AgQ/RZ0=";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv hyprfocus.so $out/lib/libhyprfocus.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  meta = {
    homepage = "https://github.com/pyt0xic/hyprfocus";
    description = "Focus animation plugin for Hyprland inspired by Flashfocus";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
