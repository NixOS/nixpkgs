{

  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libxml2,
  libusb1,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdl";
<<<<<<< HEAD
  version = "2.4";
=======
  version = "2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qdl";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-8jkuSNK7xTBUkBWzh766zKOlh+7pTr+e0xT1w3xifsw=";
=======
    hash = "sha256-aC5c22gSrQ6EKEZ0vNdfBQF+ZKRN3jrgTB1KUXGLEPA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace Makefile --replace-fail 'pkg-config' '${stdenv.cc.targetPrefix}pkg-config'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxml2
    libusb1
  ];

  makeFlags = [
    "VERSION=${finalAttrs.src.rev}"
    "prefix=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/linux-msm/qdl";
    description = "Tool for flashing images to Qualcomm devices";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      muscaln
      anas
      numinit
    ];
    platforms = lib.platforms.linux;
    mainProgram = "qdl";
  };
})
