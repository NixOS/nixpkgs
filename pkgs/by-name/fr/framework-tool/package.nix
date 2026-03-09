{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framework-tool";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lpd6686qN06WgJbs1PuCIFMRGEqBFtQqyVauKGG9jH4=";
  };

  cargoHash = "sha256-y17Qlw8D7XWcStJ/54h1ARgODg1htzf9FVKjFZGERss=";

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
})
