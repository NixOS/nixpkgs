{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "framework-tool";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${version}";
    hash = "sha256-WhdKU6vyOm5R9RInw9Fj8gELztLn4m5rFGgHbnItguU=";
  };

  cargoHash = "sha256-A7/Q4p26W0AzqlLguL2OJtmm7dAsBU/Yb636ScYXrPs=";

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
      johnazoidberg
    ];
    mainProgram = "framework_tool";
  };
}
