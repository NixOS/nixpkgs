{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "torq";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "lncapital";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fqHJZi1NQCrZqsa+N+FVYZ8s9o0D555Sqn5qNlJ1MmI=";
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
