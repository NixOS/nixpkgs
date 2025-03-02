{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "s5";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QQMnzDRWdW0awwNx2vqtzrOW9Ua7EmJ9YFznQoK33J0=";
  };

  vendorHash = "sha256-axcZ4XzgsPVU9at/g3WS8Hv92P2hmZRb+tUfw+h9iH0=";

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "cipher/decipher text within a file";
    mainProgram = "s5";
    homepage = "https://github.com/mvisonneau/s5";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ mvisonneau ];
  };
}
