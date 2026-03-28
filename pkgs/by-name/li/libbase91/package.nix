{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "libbase91";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "base91";
    rev = "v${version}";
    hash = "sha256-S5gWC2SmN5lAjfFGK0z31ZL//pRXQG2qLk3RMnzuiys=";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    llvmPackages.clang
    llvmPackages.bintools
  ];

  buildPhase = ''
    clang -O2 -fPIC -shared -o libbase91.so base91.c
    clang -O2 -c base91.c -o base91.o
    llvm-ar crs libbase91.a base91.o
  '';

  installPhase = ''
    mkdir -p $out/lib $out/include $out/share/man/man3
    cp libbase91.so libbase91.a $out/lib/
    cp base91.h $out/include/
    for f in ${src}/rust/base91-cli/man/man3/*.3; do
      install -Dm444 "$f" $out/share/man/man3/$(basename "$f")
    done
  '';

  meta = {
    description = "basE91 C library";
    homepage = "https://github.com/douzebis/base91";
    changelog = "https://github.com/douzebis/base91/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ douzebis ];
    platforms = lib.platforms.unix;
  };
}
