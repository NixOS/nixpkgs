{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libusb1,
  libftdi,
  cargo-readme,
  pkg-config,
}:

rustPlatform.buildRustPackage {
  pname = "humility";
  version = "0-unstable-2025-02-25";

  nativeBuildInputs = [
    pkg-config
    cargo-readme
  ];
  buildInputs = [
    libusb1
    libftdi
  ];

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "humility";
    rev = "4e9b9f9efb455d62b44345b7c8659dcd962c73da";
    sha256 = "sha256-BzLduU2Wu4UhmgDvvuCEXsABO/jPC7AjptDW8/zePEk=";
  };

  cargoHash = "sha256-GZkHPoDKiqTVwRAWXXbELXC1I/KRO+9sshY8/rGbA4A=";

  meta = with lib; {
    description = "Debugger for Hubris";
    mainProgram = "humility";
    homepage = "https://github.com/oxidecomputer/humility";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ therishidesai ];
  };
}
