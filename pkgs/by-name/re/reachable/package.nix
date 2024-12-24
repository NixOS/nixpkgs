{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "reachable";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "italolelis";
    repo = "reachable";
    rev = version;
    hash = "sha256-pEwqJidB+mRnic92K+y21h/ETuocTzlZNVVwCnmFeaA=";
  };
  vendorHash = "sha256-Imu8OWpywSszAmUD4FhR7lw2/zsgGl2QV8Edzob7RTA=";

  ldflags = [
    "-X cmd.version=${version}"
  ];

  meta = {
    description = "Reachable is a CLI tool to check if a domain is up ";
    homepage = "https://github.com/italolelis/reachable";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ darwincereska ];
    mainProgram = "reachable";
  };

}