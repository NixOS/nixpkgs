{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "nping-rs";
  version = "0.5.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hanshuaikang";
    repo = "Nping";
    tag = "v${version}";
    hash = "sha256-WxevLHBvJHAQMU27Xi5XR9+KYfVRsIW3qM/uUu6+ieg=";
  };

  cargoHash = "sha256-rEyqQx2ZhMlS1u6bWeOmjyxLX7AGt+toGi8tsShSvJs=";

  meta = {
    description = "Ping Tool in Rust with Real-Time Data and Visualizations";
    homepage = "https://github.com/hanshuaikang/Nping";
    changelog = "https://github.com/hanshuaikang/Nping/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "nping-rs";
  };
}
