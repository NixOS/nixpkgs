{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nkeys";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/nqYTJq8QPRR6ADAg1300I52agdoR7o84eumRjQY6xU=";
  };

  vendorHash = "sha256-NHblFXIRK9moaZKBdfm61Ueo+GH/lGmVhrzYvMvYhjA=";

  meta = with lib; {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    changelog = "https://github.com/nats-io/nkeys/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nk";
  };
}
