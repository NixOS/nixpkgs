{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framework-tool";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EpStj1uMh0IkzXA5eI/xOndzDCxyJITqKGaSHqnJEFs=";
  };

  cargoHash = "sha256-SVipNctgdU5oJiKbDnUmpv99Hc0W6nFtnI/DB90ndCo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

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
