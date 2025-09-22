{
  lib,
  stdenv,
  fetchFromGitHub,
  rust,
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
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "libimagequant";
    rev = version;
    hash = "sha256-2P8FiRfOuCHxJrB+rnDDOFsrFjPv5GMBK/5sq7eb32w=";
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
    ${rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    popd
  '';

  postInstall = ''
    pushd imagequant-sys
    ${rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
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

  meta = with lib; {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma9e ];
  };
}
