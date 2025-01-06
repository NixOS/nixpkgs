{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "swapview";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "swapview";
    rev = "v${version}";
    sha256 = "0339biydk997j5r72vzp7djwkscsz89xr3936nshv23fmxjh2rzj";
  };

  cargoHash = "sha256-v3Fd08s70YX7pEIWYcgpC2daerfZhtzth4haKfUy0Q8=";

  meta = {
    description = "Simple program to view processes' swap usage on Linux";
    mainProgram = "swapview";
    homepage = "https://github.com/lilydjwg/swapview";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
