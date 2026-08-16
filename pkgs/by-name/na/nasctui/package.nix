{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  libqalculate,
}:

buildGoModule (finalAttrs: {
  pname = "nasctui";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "parnoldx";
    repo = "nascTUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h9tdoQv/Uj9r3RSvmUBGa+aFHxAlhpy4yIrKhrg/aAE=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-ys9VEv8PisvO9UCD6M3aLrJeF88ZNAUATxyTVV02z44=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libqalculate
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Do maths like a normal person - A terminal calculator";
    homepage = "https://github.com/parnoldx/nascTUI";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "nasc";
    platforms = lib.platforms.linux;
  };
})
