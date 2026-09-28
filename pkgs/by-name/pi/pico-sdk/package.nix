{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nix-update-script,
  pico-sdk,

  # Options

  # The submodules in the pico-sdk contain important additional functionality
  # such as tinyusb, but not all these libraries might be bsd3.
  # Off by default.
  withSubmodules ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pico-sdk";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "pico-sdk";
    tag = finalAttrs.version;
    fetchSubmodules = withSubmodules;
    hash =
      if withSubmodules then
        "sha256-ZWGJNQwbkGlgZnEoOoMishX4ANZAqqkMeck8uZlewVk="
      else
        "sha256-UWWrZT7Mg2yei/LlDxgei3yXWaP9ETMlgiVOFFAEMZ8=";
  };

  cmakeFlags = [
    (lib.cmakeFeature "PIOASM_VERSION_STRING" finalAttrs.version)
  ];

  nativeBuildInputs = [ cmake ];

  # SDK contains libraries and build-system to develop projects for RP2040 chip
  # We only need to compile pioasm binary
  sourceRoot = "${finalAttrs.src.name}/tools/pioasm";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/pico-sdk
    cp -a ../../../* $out/lib/pico-sdk/
    chmod 755 $out/lib/pico-sdk/tools/pioasm/build/pioasm
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "tests.withSubmodules"
      ];
    };
    tests = {
      withSubmodules = pico-sdk.override { withSubmodules = true; };
    };
  };

  meta = {
    description = "SDK provides the headers, libraries and build system necessary to write programs for the RP2040-based devices";
    homepage = "https://github.com/raspberrypi/pico-sdk";
    changelog = "https://github.com/raspberrypi/pico-sdk/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      muscaln
      nulleric
    ];
    platforms = lib.platforms.unix;
  };
})
