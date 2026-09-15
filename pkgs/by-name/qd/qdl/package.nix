{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  libxml2,
  libusb1,
  libzip,
  nbdkit,
  zip,
  cmocka,
  ninja,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdl";
  version = "2.8";

  __structuredAttrs = true;

  # with true: "Run-time dependency cmocka found: NO (tried pkgconfig)"
  strictDeps = false;

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ysL9tO1GKvzphxezMspGMW8kkUNGHHspA1YU+v5HA/A=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];
  buildInputs = [
    libxml2
    libusb1
    libzip
    nbdkit
  ];
  nativeCheckInputs = [
    cmocka
    zip
  ];

  mesonFlags = [
    "--prefix=${placeholder "out"}"
    "-DVERSION=${finalAttrs.version}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
