{ lib, buildGoModule, fetchFromGitHub, bash, go, python3, ruby }:

buildGoModule rec {
  pname = "slides";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "slides";
    rev = "v${version}";
    sha256 = "175g823n253d3xg8hxycw3gm1hhqb0vz8zs7xxcbdw5rlpd2hjii";
  };

  checkInputs = [
    bash
    go
    python3
    ruby
  ];

  vendorSha256 = "13kx47amwvzyzc251iijsbwa52s8bpld4xllb4y85qkwllfnmq2g";

  ldflags = [
    "-s" "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Terminal based presentation tool";
    homepage = "https://github.com/maaslalani/slides";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani ];
  };
}
