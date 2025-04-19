{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "framework-tool";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${version}";
    hash = "sha256-5rcmi1mnEMZnxVJ9rJ6rBNqweLBbCX9J3tbjD0VrSBk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vaNel+IUX+ALgkpv7sRRp3fHn/NjxsWuctU0WMOS/44=";

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
