{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hextazy";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "0xfalafel";
    repo = "hextazy";
    rev = "${version}";
    hash = "sha256-EdcUAYT/3mvoak+6HIV6z0jvFTyjuS7WpT2kivQKpyg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1i0nngfqF4R/ILbNHrCW1NIEFTfQ5nRhjdKy7uebPi8=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/0xfalafel/hextazy";
    changelog = "https://github.com/0xfalafel/hextazy/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
}
