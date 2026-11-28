{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  libusb1,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brother-pe-core";
  version = "0.4.2";

  src = fetchFromGitLab {
    owner = "dlarochette";
    repo = "brother-pe-core";
    tag = finalAttrs.version;
    hash = "sha256-+QQT8UTB47S6+93yGi5zREzD8XnlojQWbg13RwezX/g=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
    zlib
  ];

  # Installs the udev rule under $out/lib/udev/rules.d, for services.udev.packages.
  cmakeFlags = [ (lib.cmakeFeature "BROTHERPE_UDEV_RULES_DIR" "lib/udev/rules.d") ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Driver library for the Brother USB embroidery card writer and embroidery formats";
    longDescription = ''
      libbrother-pe drives the Brother USB embroidery card reader/writer
      (04f9:2100, sold with PED-Basic and PE-Design): card writer protocol,
      simulator, card image codec, embroidery pattern model and formats (PES,
      PEC, DST, EXP, JEF, VP3, XXX, G-code, SVG), PNG rendering and G-code
      streaming. The package also ships the udev rule that grants the local
      session access to the reader; on NixOS, add this package to
      services.udev.packages.
    '';
    homepage = "https://gitlab.com/dlarochette/brother-pe-core";
    changelog = "https://gitlab.com/dlarochette/brother-pe-core/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dlarochette ];
    platforms = lib.platforms.linux;
  };
})
