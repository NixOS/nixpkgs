{ lib, stdenv, fetchFromGitHub, SDL_compat }:

stdenv.mkDerivation rec {
  pname = "rvvm";
  version = "unstable-2023-01-25";

  src = fetchFromGitHub {
    owner = "LekKit";
    repo = "RVVM";
    rev = "4de27d7083db34bd074b4f056d6eb3871ccf5c10";
    sha256 = "sha256-FjEcXfweL6FzA6iLxl9XnKaD4Fh/wZuRTJzZzHkc/B4=";
  };

  buildInputs = [ SDL_compat ];

  makeFlags =
    [ "BUILDDIR=out" "BINARY=rvvm" "USE_SDL=1" "GIT_COMMIT=${src.rev}" "all" "lib" ]
    # work around https://github.com/NixOS/nixpkgs/issues/19098
    ++ lib.optional (stdenv.cc.isClang && stdenv.isDarwin) "CFLAGS=-fno-lto";

  installPhase = ''
    runHook preInstall

    install -d    $out/{bin,lib,include/devices}
    install -m755 out/rvvm           -t $out/bin
    install -m755 out/librvvm.{a,so} -t $out/lib
    install -m644 src/rvvmlib.h      -t $out/include
    install -m644 src/devices/*.h    -t $out/include/devices

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/LekKit/RVVM";
    description = "The RISC-V Virtual Machine";
    license = with licenses; [ gpl3 /* or */ mpl20 ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ nebulka ];
  };
}
