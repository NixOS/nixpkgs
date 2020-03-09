{ stdenv, fetchFromGitHub, rustPlatform, ncurses }:

rustPlatform.buildRustPackage {
  pname = "hexdino";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Luz";
    repo = "hexdino";
    rev = "de5b5d7042129f57e0ab36416a06476126bce389";
    sha256 = "11mz07735gxqfamjcjjmxya6swlvr1p77sgd377zjcmd6z54gwyf";
  };

  cargoSha256 = "06ghcd4j751mdkzwb88nqwk8la4zdb137y0iqrkpykkfx0as43x3";

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "A hex editor with vim like keybindings written in Rust";
    homepage = https://github.com/Luz/hexdino;
    license = licenses.mit;
    maintainers = [ maintainers.luz ];
    platforms = platforms.all;
  };
}
