{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sqlite,
  corrosion,
  rustPlatform,
  cargo,
  rustc,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libchewing";
<<<<<<< HEAD
  version = "0.10.3";
=======
  version = "0.9.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "chewing";
    repo = "libchewing";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-rUkLwE5PvFcMxTwb2zVzWaa20D3ZW1MXl3Cra+Wim04=";
=======
    hash = "sha256-5aeAsvTiUMTm+ibNfJI57rzSUpJB7luhA/aWmTcnBj4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # ld: unknown option: -version-script
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "if(CMAKE_C_COMPILER_ID MATCHES GNU|^Clang)" "if((CMAKE_C_COMPILER_ID MATCHES GNU|^Clang) AND NOT APPLE)"
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
<<<<<<< HEAD
    hash = "sha256-+BmJOouajL3ib08t96TAHtNXBX48wq614LSbcSgYpIM=";
=======
    hash = "sha256-LTuUhQ0ZeyGloNvVs+6OGjFvPdBsQNZupwC8QTjUfyk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    sqlite
    corrosion
  ];

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Intelligent Chinese phonetic input method";
    homepage = "https://chewing.im/";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    platforms = lib.platforms.all;
    # compile time tools init_database, dump_database are built for host
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
})
