{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "framework-tool";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${version}";
    hash = "sha256-tC20ca5dRGumRQAcdGLOtEPAwBYYUg6+j7Xbowp3WAo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W2kiZB/ddXGpKVfaYlpaEBSYtp6EdXs/vMKenYcA+EY=";

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
