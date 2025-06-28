{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "framework-tool";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${version}";
    hash = "sha256-gO7ieyVQzK3BkNsy451WNtrx51jlzd6vhwJX8RDoj/o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fgDZgWQGQEN2dLJjghngqeOLDX+0joSiI6OigGC57Hc=";

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
