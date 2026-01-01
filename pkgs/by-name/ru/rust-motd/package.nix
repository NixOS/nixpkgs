{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-motd";
<<<<<<< HEAD
  version = "2.1.2";
=======
  version = "2.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rust-motd";
    repo = "rust-motd";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-xZwp4bCG9BMqFmLa89fh/wAkM42Vx3+vNq+AnnDa620=";
  };

  cargoHash = "sha256-cwsszuIeQp5HIHqUYh70/7kNAYZG+xJxHB87Hzk4fK8=";
=======
    hash = "sha256-8XuOleWJxNKXkFK330e2a4hGTCOx83kMgya2EPojqVQ=";
  };

  cargoHash = "sha256-el+7lzX28lxclwfq0ulehtZ5+Gv4ISHxPt1DXqwDBzc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

<<<<<<< HEAD
  env.OPENSSL_NO_VENDOR = 1;
=======
  OPENSSL_NO_VENDOR = 1;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Beautiful, useful MOTD generation with zero runtime dependencies";
    homepage = "https://github.com/rust-motd/rust-motd";
    changelog = "https://github.com/rust-motd/rust-motd/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "rust-motd";
  };
}
