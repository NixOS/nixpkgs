{ buildGoModule
, fetchFromGitHub
, lib
, nixosTests
}:

buildGoModule rec {
  pname = "blocky";
<<<<<<< HEAD
  version = "0.22";
=======
  version = "0.21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-iU7fpTn8sPtglZfqLJ6fVYbHtYp0jqItSpJsvN4iKE8=";
=======
    sha256 = "sha256-+88QMASMEY1pJuejFUqqW1Ky7TpoSwCzUy1oueL7FKU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go
  doCheck = false;

<<<<<<< HEAD
  vendorHash = "sha256-PnqpDAbHCs1wFudYy+nyG+p/E6ig7ZuhbuU4CFFoiyk=";
=======
  vendorSha256 = "sha256-EsANifwaEi5PdY0Y2QZjD55sZqsqYWrC5Vh4uxpTs5A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X github.com/0xERR0R/blocky/util.Version=${version}" ];

  passthru.tests = { inherit (nixosTests) blocky; };

  meta = with lib; {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features.";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ ratsclub ];
  };
}
