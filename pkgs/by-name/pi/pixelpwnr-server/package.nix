{ lib, stdenv, rustPlatform, fetchFromGitHub, cmake, freetype, libX11
, libXcursor, libXrandr, libXi, libGL, pkg-config }:

rustPlatform.buildRustPackage {
  pname = "pixelpwnr-server";
  version = "unstable-2024-03-13";

  src = fetchFromGitHub {
    owner = "timvisee";
    repo = "pixelpwnr-server";
    rev = "4abc3e0ef92f6444a8f7b67cb36367a304217bd7";
    hash = "sha256-RakDcxDIov+HCaxJ5Tx62aFIt+1NhdJ+J164lc4ptrI=";
  };

  cargoHash = "sha256-N3NXXIX5kzEmKTDpNzJgnSqJWNctupjm69mGYVteKIU=";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ freetype libX11 libXcursor libXrandr libXi ];

  postFixup = lib.optionalString stdenv.targetPlatform.isElf ''
    patchelf $out/bin/pixelpwnr-server --add-needed libGL.so --add-rpath ${
      lib.makeLibraryPath [ libGL ]
    }
  '';

  meta = with lib; {
    homepage = "https://timvisee.com/projects/pixelpwnr-server";
    description =
      "Blazingly fast GPU accelerated pixelflut server written in Rust";
    license = licenses.gpl3;
    mainProgram = "pixelpwnr-server";
  };
}

