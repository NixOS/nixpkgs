{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libusb1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ecpdap";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "adamgreig";
    repo = "ecpdap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8YmdwhRYNOSAAa0hTC9f5nm+TDg2GiMbML+qNxJP3lw=";
  };

  cargoHash = "sha256-Qz5yc3skpItCdoK4ffLbcT99YcOkvGfm3A/+QZ6FbBw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  doInstallCheck = true;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp drivers/*.rules $out/etc/udev/rules.d
  '';

  meta = {
    description = "Tool to program ECP5 FPGAs";
    mainProgram = "ecpdap";
    longDescription = ''
      ECPDAP allows you to program ECP5 FPGAs and attached SPI flash
      using CMSIS-DAP probes in JTAG mode.
    '';
    homepage = "https://github.com/adamgreig/ecpdap";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
