{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  vulkan-headers,
  vulkan-loader,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "steamvr-linux-fixes";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "BnuuySolutions";
    repo = "SteamVRLinuxFixes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pyIEzVGkMWtFPBFGIpxmuFw8a1lbBAOm2BrpqAwD6Hc=";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  env.NIX_CFLAGS_LINK = "-Wl,-z,noexecstack";

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DISTORM" "${python3Packages.distorm3.src}")
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 libsteamvr_linux_fixes.so -t $out/lib

    layerJson="$out/share/vulkan/implicit_layer.d/VkLayer_steamvr_linux_fixes.json"

    install -Dm644 "$src/VkLayer_steamvr_linux_fixes.json" "$layerJson"

    substituteInPlace "$layerJson" \
      --replace-fail \
        '"library_path": "./libsteamvr_linux_fixes.so"' \
        '"library_path": "'"$out"'/lib/libsteamvr_linux_fixes.so"'

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vulkan layer that patches SteamVR vrcompositor for wired HMDs";
    longDescription = ''
      A Vulkan layer that patches SteamVR's vrcompositor to address issues for
      wired headsets (Vive, Index, Beyond, PSVR2, etc), applying fixes such as correct
      refresh rate support, frame presentation latency via VK_KHR_present_wait,
      FIFO_LATEST_READY on NVIDIA, swapchain usage flags for Mesa, and a crash
      on zero-sized texture allocation.

      Add to programs.steam.extraPackages to use with Steam on NixOS. The layer
      activates automatically via the Vulkan implicit layer mechanism and can be
      disabled at runtime by setting DISABLE_STEAMVR_LINUX_FIXES=1.
    '';
    homepage = "https://github.com/BnuuySolutions/SteamVRLinuxFixes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Kitsune ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
