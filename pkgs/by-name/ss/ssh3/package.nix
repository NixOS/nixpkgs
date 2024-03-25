{ lib
, buildGoModule
, fetchFromGitHub
, libxcrypt
}:

buildGoModule rec {
  pname = "ssh3";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "francoismichel";
    repo = "ssh3";
    rev = "v${version}";
    hash = "sha256-A52PX24vr2TP0vWjCK34tkXqVCaPS1ebMDoQ97aXa7o=";
  };

  buildInputs = [
    libxcrypt
  ];

  vendorHash = "sha256-VUNvb7m1nnH+mXUsnIKyPKJEVSMXBAaS4ihi5DZeFiI=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Revisit of the SSH protocol using QUIC + TLS 1.3 and HTTP authorization";
    homepage = "https://github.com/francoismichel/ssh3";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
    mainProgram = "ssh3";
  };
}
