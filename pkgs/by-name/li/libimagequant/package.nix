{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  rustPlatform,
  cargo-c,
  python3,

  # tests
  testers,
  vips,
  libimagequant,
}:

rustPlatform.buildRustPackage rec {
  pname = "libimagequant";
<<<<<<< HEAD
  version = "4.4.1";
=======
  version = "4.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "libimagequant";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-A7idjAAJ+syqIahyU+LPZBF+MLxVDymY+M3HM7d/qk0=";
=======
    hash = "sha256-c9j0wVwTWtNrPy9UUsc0Gxbe6lP82C3DMXe+k/ZBYEw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoLock = {
    # created it by running `cargo update` in the source tree.
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ cargo-c ];

  postBuild = ''
    pushd imagequant-sys
    ${buildPackages.rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    popd
  '';

  postInstall = ''
    pushd imagequant-sys
    ${buildPackages.rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    popd
  '';

  passthru.tests = {
    inherit vips;
    inherit (python3.pkgs) pillow;

    pkg-config = testers.hasPkgConfigModules {
      package = libimagequant;
      moduleNames = [ "imagequant" ];
    };
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ma9e ];
=======
  meta = with lib; {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma9e ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
