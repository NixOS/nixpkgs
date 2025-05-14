{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "framework-tool";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "framework-system";
    tag = "v${version}";
    hash = "sha256-JPIpaAfXraqU6YM31bLImeJUCD3/O+PLcaZBxUjDqlM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Kf3DXEDpCbbixUjeyBi1xkR32sW2uuasxqeWeq/X2Xk=";

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
