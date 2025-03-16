{ lib
, fetchFromGitHub
, rustPlatform
, python3

# tests
, vips
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

  buildCAPIOnly = true;
  cargoCFlags = [ "--package=imagequant-sys" ];

  passthru.tests = {
    inherit vips;
    inherit (python3.pkgs) pillow;
  };

  meta = with lib; {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma9e ];
    pkgConfigModules = [ "imagequant" ];
  };
}
