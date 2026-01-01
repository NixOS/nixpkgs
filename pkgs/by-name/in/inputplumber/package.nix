{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  libiio,
  libevdev,
}:

rustPlatform.buildRustPackage rec {
  pname = "inputplumber";
<<<<<<< HEAD
  version = "0.70.1";
=======
  version = "0.68.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "InputPlumber";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Sk1z1bJlpHQrbm7rSiLHiwFXCwlZ/Qcr5vyY7ydLktw=";
  };

  cargoHash = "sha256-Alnr8ppttft4GavoErFkZ7rqnAKaTDCyPhfqAcMX+R0=";
=======
    hash = "sha256-nnHRdqX5q9WSu8d/jwTgelncCVs1UnV8Z0aae42KUls=";
  };

  cargoHash = "sha256-yfZzkVALrD/dgANS4O/JCJPgepzMmqYMQ087Fmtlw68=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    libevdev
    libiio
  ];

  postInstall = ''
    cp -r rootfs/usr/* $out/
  '';

  meta = {
    description = "Open source input router and remapper daemon for Linux";
    homepage = "https://github.com/ShadowBlip/InputPlumber";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/ShadowBlip/InputPlumber/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "inputplumber";
  };
}
