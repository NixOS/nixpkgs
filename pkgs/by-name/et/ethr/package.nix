{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "ethr";
  version = "1.0.0-unstable-2025-12-10";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "ethr";
    rev = "86e07049d11357f69da89317d55f11bed62e0007";
    hash = "sha256-lkhqPq2EDI3J8jiNx0Gygf8fDZvtZ2Pw3rRSt4HVBq8=";
  };

  vendorHash = "sha256-UHZNe6vlqdYaHzt2IZ5HTQxqR0sf8m9Lfo5tXvpiFlg=";

  # Strip symbol table and DWARF debug info to reduce binary size
  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Comprehensive Network Measurement Tool for TCP, UDP & ICMP";
    homepage = "https://github.com/microsoft/ethr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.philiptaron ];
    mainProgram = "ethr";
  };
}
