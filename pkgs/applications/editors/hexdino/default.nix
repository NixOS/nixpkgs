{ lib, fetchFromGitHub, rustPlatform, ncurses }:

rustPlatform.buildRustPackage {
  pname = "hexdino";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Luz";
    repo = "hexdino";
    rev = "de5b5d7042129f57e0ab36416a06476126bce389";
    sha256 = "11mz07735gxqfamjcjjmxya6swlvr1p77sgd377zjcmd6z54gwyf";
  };

  cargoSha256 = "16958ps3wwsq4myxv66yspdisp75prkz973f7kwm7n46g67f25pb";

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "A hex editor with vim like keybindings written in Rust";
    homepage = "https://github.com/Luz/hexdino";
    license = licenses.mit;
    maintainers = [ maintainers.luz ];
  };
}
