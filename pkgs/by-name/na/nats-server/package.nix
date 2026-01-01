{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nats-server";
<<<<<<< HEAD
  version = "2.12.3";
=======
  version = "2.12.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-server";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VLNo2XuTBUYR/zzgtjO4uzzOFaqpm8p0iW2mjCxvVSA=";
  };

  vendorHash = "sha256-Ik3RYk9GjEkKyp/Uu89rbiSnX6dN/ukpVVFU8tu3C5o=";
=======
    hash = "sha256-03BtUlCf1GxrtQGz6gDxfqVeZy9rSxCTqZLZeMQhbWw=";
  };

  vendorHash = "sha256-Ydo4pRRcQo2R1Bc9BGPvAMwgbMG3ZhbislK3FlejqdY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = {
    description = "High-Performance server for NATS";
    mainProgram = "nats-server";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      swdunlop
      derekcollison
    ];
  };
}
