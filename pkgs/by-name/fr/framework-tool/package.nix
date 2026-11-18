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
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r/WkdEmvz9Rva6e2to+Tp2oXCLzK94P2odL/o/4GM1A=";
  };

  cargoHash = "sha256-JMVuDerKrNW795qMNzzpeViJEVaGoLevNLaup6705og=";

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
