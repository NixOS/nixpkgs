{ lib
, stdenv
, pkg-config
, fetchFromGitHub
, libusb1
}:

# IMPORTANT: You need permissions to access the stlink usb devices.
# Add services.udev.packages = [ pkgs.stlink ] to your configuration.nix
stdenv.mkDerivation {
  pname = "stlink-tool";
  version = "0-unstable-2020-06-10";

  src = fetchFromGitHub {
    owner = "jeanthom";
    repo = "stlink-tool";
    rev = "8cbdffee012d5a782dd67d1277ed22fa889b9ba9";
    hash = "sha256-1Mk4rFyIviJ9hcJo1GyzRmlPIemBJtuj3PgvnNhche0=";
    fetchSubmodules = true;
  };

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkg-config ];

  env.NIX_CFLAGS_COMPILE = "-Wno-uninitialized";

  installPhase = ''
    runHook preInstall
    install -D stlink-tool $out/bin/stlink-tool
    runHook postInstall
  '';

  meta = with lib; {
    description = "libusb tool for flashing chinese ST-Link dongles";
    homepage = "https://github.com/jeanthom/stlink-tool";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.wucke13 ];
    mainProgram = "stlink-tool";
  };
}
