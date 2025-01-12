{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "hotpatch";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "vikasnkumar";
    repo = "hotpatch";
    rev = "4b65e3f275739ea5aa798d4ad083c4cb10e29149";
    sha256 = "169vdh55wsbn6fl58lpzqx64v6ifzh7krykav33x1d9hsk98qjqh";
  };

  doCheck = true;

  nativeBuildInputs = [ cmake ];

  preConfigure = ''
    substituteInPlace test/loader.c \
      --replace \"/lib64/ld-linux-x86-64.so.2 \""$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --replace \"/lib/ld-linux-x86-64.so.2 \""$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --replace \"/lib/ld-linux.so.2 \""$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --replace \"/lib32/ld-linux.so.2 \""$(cat $NIX_CC/nix-support/dynamic-linker)"
  '';

  checkPhase = ''
    LD_LIBRARY_PATH=$(pwd)/src make test
  '';

  patches = [ ./no-loader-test.patch ];

  meta = with lib; {
    description = "Hot patching executables on Linux using .so file injection";
    mainProgram = "hotpatcher";
    homepage = src.meta.homepage;
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = ["i686-linux" "x86_64-linux"];
  };
}
