{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scout";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9SimePyBUXXfT4+ZtciQMaoyXpyKi9D3LTwud8QMJ6w=";
  };

  vendorHash = "sha256-reoE3WNgulREwxoeGFEN1QONZ2q1LHmQF7+iGx0SGTY=";

  meta = with lib; {
    description = "Lightweight URL fuzzer and spider: Discover a web server's undisclosed files, directories and VHOSTs";
    mainProgram = "scout";
    homepage = "https://github.com/liamg/scout";
    platforms = platforms.unix;
    license = licenses.unlicense;
    maintainers = with maintainers; [ totoroot ];
  };
}
