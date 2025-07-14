{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pingu";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "sheepla";
    repo = "pingu";
    rev = "v${version}";
    sha256 = "sha256-iAHj6/qaZgpTfrUZZ9qdsjiNMJ2zH0CzhR4TVSC9oLE=";
  };

  vendorHash = "sha256-xn6la6E0C5QASXxNee1Py/rBs4ls9X/ePeg4Q1e2UyU=";

  meta = with lib; {
    description = "Ping command implementation in Go but with colorful output and pingu ascii art";
    homepage = "https://github.com/sheepla/pingu/";
    license = licenses.mit;
    maintainers = with maintainers; [ CactiChameleon9 ];
    mainProgram = "pingu";
    # Doesn't build with Go toolchain >1.22, build error:
    # 'link: golang.org/x/net/internal/socket: invalid reference to syscall.recvmsg'.
    broken = true;
  };
}
