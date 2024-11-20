{
  lib,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  systemd,
}:
rustPlatform.buildRustPackage rec {
  pname = "inputmodule-control";
  version = "0.2.0-unstable-2024-11-17";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "inputmodule-rs";
    rev = "262edffd35ad6aa7976aee38632f6b75695bc0a8";
    hash = "sha256-d9Tvxch9VZbaWzwe69oQMqlCRcirkrtoFJd2SaXh+wY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iqB0JxRlIwdjTh+dPa3W5bwYVOFGWObmBXUETZC6Rk8=";
  buildAndTestSubdir = "inputmodule-control";

  buildInputs = [ systemd ];
  nativeBuildInputs = [ pkg-config ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp release/50-framework-inputmodule.rules $out/lib/udev/rules.d/50-framework-inputmodule.rules
  '';

  meta = with lib; {
    description = "Framework Laptop 16 Input Module";
    homepage = "https://github.com/FrameworkComputer/inputmodule-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ dsluijk ];
    mainProgram = "inputmodule-control";
    platforms = platforms.linux;
  };
}
