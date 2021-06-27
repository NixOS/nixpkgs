{ lib, buildGoModule, fetchFromGitHub, bash, go, python3, ruby, sd }:

buildGoModule rec {
  pname = "slides";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "slides";
    rev = "v${version}";
    sha256 = "00sml6b9q3df9dgl7fpsn6a3qkq6xklnbfvvblf91xdf4ssn7wrx";
  };

  checkInputs = [
    bash
    go
    python3
    ruby
    sd
  ];

  vendorSha256 = "0y6fz9rw702mji571k0gp4kpfx7xbv7rvlnmpfjygy6lmp7wga6f";

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
