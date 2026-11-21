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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "BnuuySolutions";
    repo = "SteamVRLinuxFixes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ls8pP/PDh3Zn2BQv+D/XCUAzFCV6NqlBm1TOSs/tQgo=";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DISTORM" "${python3Packages.distorm3.src}")
  ];

  postInstall = ''
    substituteInPlace $out/share/vulkan/implicit_layer.d/VkLayer_steamvr_linux_fixes.json \
      --replace-fail \
        '"library_path": "../../../lib/libsteamvr_linux_fixes.so"' \
        '"library_path": "'"$out"'/lib/libsteamvr_linux_fixes.so"'
  '';

  passthru.updateScript = nix-update-script { };

  strictDeps = true;
  __structuredAttrs = true;

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
