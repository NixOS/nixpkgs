{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "torq";
  version = "0.16.15";

  src = fetchFromGitHub {
    owner = "lncapital";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ibrPq/EC61ssn4072gTNvJg9QO41+aTsU1Hhc6X6NPk=";
  };

  vendorHash = "sha256-HETN2IMnpxnTyg6bQDpoD0saJu+gKocdEf0VzEi12Gs=";

  subPackages = [ "cmd/torq" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/lncapital/torq/build.version=v${version}"
  ];

  meta = with lib; {
    description = "Capital management tool for lightning network nodes";
    license = licenses.mit;
    homepage = "https://github.com/lncapital/torq";
    maintainers = with maintainers; [ mmilata prusnak ];
  };
}
