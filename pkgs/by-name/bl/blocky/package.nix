{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGoModule rec {
  pname = "blocky";
<<<<<<< HEAD
  version = "0.28.2";
=======
  version = "0.27.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = "blocky";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-GLVyPb2Qyn1jnRz+e74dFzL/AMloKqSe1BUUAGTquWA=";
=======
    hash = "sha256-N0zQb30PHTbTsQQgljuIW/We1i9ITLFdonOX4L+vk+o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go
  doCheck = false;

<<<<<<< HEAD
  vendorHash = "sha256-AzfI4SElD7GFIG8/REB4PU0/Haj5x5HUNj/3/n1OXZE=";
=======
  vendorHash = "sha256-YwwqGLfMnlQGRkTPfSmRnzUzu8+O5JzOPev6aSxBXbQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/0xERR0R/blocky/util.Version=${version}"
  ];

  passthru.tests = { inherit (nixosTests) blocky; };

<<<<<<< HEAD
  meta = {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ratsclub ];
=======
  meta = with lib; {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ ratsclub ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "blocky";
  };
}
