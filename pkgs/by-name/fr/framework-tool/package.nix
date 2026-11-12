{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framework-tool";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AcATahEiCiXUNC4k9dCW6doGchjdvg6Kc7VjaOYyFGk=";
  };

  cargoHash = "sha256-gc/diU6reAaFnar1HZ4tMzYsGo8k3LH35g9Er5T8xas=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    udev
  ];

  meta = {
    description = "Swiss army knife for Framework laptops";
    homepage = "https://github.com/FrameworkComputer/framework-system";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      nickcao
      kloenk
      johnazoidberg
    ];
    mainProgram = "framework_tool";
  };
})
