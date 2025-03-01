{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "elfcat";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "ruslashev";
    repo = pname;
    rev = version;
    sha256 = "sha256-NzFKNCCPWBj/fhaEJF34nyeyvLMeQwIcQgTlYc6mgYo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-CwK+xc77QADjQyrCI6NIrZ2A/DgnNfs57p9wdKJQZ4w=";

  meta = with lib; {
    description = "ELF visualizer, generates HTML files from ELF binaries";
    homepage = "https://github.com/ruslashev/elfcat";
    license = licenses.zlib;
    maintainers = with maintainers; [ moni ];
    mainProgram = "elfcat";
  };
}
