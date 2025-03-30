{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "framework-tool";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${version}";
    hash = "sha256-wWattGkBn8WD3vfThlQnotQB4Q/C00AZT1BesoHcCyg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kmrgtYXo2Xh4mBk64VE83UJdITHgA/y3VeBRE8gDUTY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = {
    description = "Swiss army knife for Framework laptops";
    homepage = "https://github.com/FrameworkComputer/framework-system";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      nickcao
      leona
      kloenk
    ];
    mainProgram = "framework_tool";
  };
}
