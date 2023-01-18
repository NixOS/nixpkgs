{ lib
, buildGoModule
, fetchFromGitHub }:

buildGoModule rec {
  pname = "torq";
  version = "0.16.9";

  src = fetchFromGitHub {
    owner = "lncapital";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jr4DNjHP8xVtl0Y1egVUmvzLRR6YjyUqvvhOAZNKFu0=";
  };

  vendorHash = "sha256-HETN2IMnpxnTyg6bQDpoD0saJu+gKocdEf0VzEi12Gs=";

  subPackages = [ "cmd/torq" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/lncapital/torq/build.Repository=github.com/${src.owner}/${src.repo}"
    "-X github.com/lncapital/torq/build.overrideBuildVer=${version}"
  ];

  meta = with lib; {
    description = "Capital management tool for lightning network nodes";
    license = licenses.mit;
    homepage = "https://github.com/lncapital/torq";
    maintainers = with maintainers; [ mmilata prusnak ];
  };
}
