{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubetui";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sarub0b0";
    repo = "kubetui";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-e2YjtshgBRx9rf0Z7VUXa767UMyWc8OnIV1yjYC0erw=";
=======
    hash = "sha256-Fa/1A37uP8dYYP5S7qzxKJv7GXVWsRvdzVTmRfQ2n/c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  checkFlags = [
    "--skip=workers::kube::store::tests::kubeconfigからstateを生成"
  ];

<<<<<<< HEAD
  cargoHash = "sha256-0D7AfhmImaNUnpN6sEY4T0io4EMXP0HPwgh30VDRQm0=";
=======
  cargoHash = "sha256-CzkXA+e0bcTU8u8Nj1OBj8Ovgzr8aDiW92AVzaYwqpA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    homepage = "https://github.com/sarub0b0/kubetui";
    changelog = "https://github.com/sarub0b0/kubetui/releases/tag/v${version}";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.mit;
    description = "Intuitive TUI tool for real-time monitoring and exploration of Kubernetes resources";
    mainProgram = "kubetui";
  };
}
