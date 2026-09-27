{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  vulkan-loader,
  vulkan-utility-libraries,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "low_latency_layer";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Korthos-Software";
    repo = "low_latency_layer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mnGAH0m19wOkWEowpcPRHXQSc6HGYW+CFYxjPF2onk4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    vulkan-utility-libraries
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "A Vulkan layer that reduces latency by implementing both AMD and NVIDIA's latency reduction technologies.";
    longDescription = ''
      A C++23 implicit Vulkan layer that reduces click-to-photon latency by implementing both AMD and NVIDIA's latency reduction technologies.
      By providing hardware-agnostic implementations of the VK_NV_low_latency2 and VK_AMD_anti_lag device extensions, this layer brings Reflex and Anti-Lag capabilities to AMD and Intel GPUs. When paired with dxvk-nvapi to forward the relevant calls, it bypasses the need for official driver-level support.
      The layer also eliminates a hardware support disparity as considerably more applications support NVIDIA's Reflex than AMD's Anti-Lag.
      To use this in NixOS add this package to hardware.graphics.extraPackages.
    '';
    homepage = "https://github.com/Korthos-Software/low_latency_layer";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      returntoreality
    ];
  };
})
