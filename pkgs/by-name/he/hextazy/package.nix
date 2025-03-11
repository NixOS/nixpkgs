{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hextazy";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "0xfalafel";
    repo = "hextazy";
    rev = "${version}";
    hash = "sha256-j8KY8OTYG+Hl86OppbMyAFBSA89TO7hc8mcNgTGTlgM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JPY1mge4aqO/QERCXYk+HzONjDJHi5og6lwQ68nUxqE=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/0xfalafel/hextazy";
    changelog = "https://github.com/0xfalafel/hextazy/releases/tags/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
}
