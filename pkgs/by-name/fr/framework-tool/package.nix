{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "framework-tool";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${version}";
    hash = "sha256-eH6EUpdITFX3FDV0LbeOnqvDmbriDT5R02jhM2DVqtA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qS65k/cqP9t71TxuqP1/0xIPkhe56WEEbzDzV6JfKrs=";

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
