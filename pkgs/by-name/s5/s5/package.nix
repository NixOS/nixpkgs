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
    repo = "s5";
    rev = "v${version}";
    hash = "sha256-QQMnzDRWdW0awwNx2vqtzrOW9Ua7EmJ9YFznQoK33J0=";
  };

  vendorHash = "sha256-axcZ4XzgsPVU9at/g3WS8Hv92P2hmZRb+tUfw+h9iH0=";

  subPackages = [ "cmd/s5" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  doCheck = true;

  meta = {
    description = "Cipher/decipher text within a file";
    mainProgram = "s5";
    homepage = "https://github.com/mvisonneau/s5";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ mvisonneau ];
  };
}
