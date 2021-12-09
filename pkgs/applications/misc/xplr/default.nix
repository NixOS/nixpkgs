{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hfx3jac7jr9w1s8i0v3w1amjip1jafrjsv4cxa5piqqjx751v5i";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "0s905wnb9r0nxwakdcs8j0f32mkbdwiabb8qa4fz9y3rawj00pkh";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
