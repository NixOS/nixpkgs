{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  meson,
  pkg-config,
  libxml2,
  libusb1,
  libzip,
  cmocka,
  ninja,
  nix-update-script,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdl";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oZ/1Pe81VOAmZiywSC2jC1OcDtaH84GAuo8AqiE77d4=";
  };

  patches = [
    # allow VERSION to be overridden, will land in 2.8
    (fetchpatch2 {
      url = "https://github.com/linux-msm/qdl/commit/6f8700ed81b3614baa12786a9845c9abeab1e178.patch";
      hash = "sha256-fDC34Wq4MadDDLHVQ5zuRKE2zD2dOMTU8EGINcJTYuI=";
    })
    # fix test linking
    (fetchpatch2 {
      url = "https://github.com/igoropaniuk/qdl/commit/a1d5e232326b97cbfd63f2d49caa9e0cc7950ab1.patch";
      hash = "sha256-RRU1YfgeVhQ4g1NYIfgoGm5/1objVTslFXeCfuCMULE=";
    })
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    cmocka
    ninja
    zip
  ];
  buildInputs = [
    libxml2
    libusb1
    libzip
  ];

  doCheck = true;

  mesonFlags = [
    "--prefix=${placeholder "out"}"
    "-DVERSION=${finalAttrs.src.rev}"
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
