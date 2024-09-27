{
  lib,
  fetchurl,
  pkg-config,
  llvmPackages,
  libffi,
  readline,
  openssl,
}:

let
  inherit (llvmPackages) stdenv llvm;
in
stdenv.mkDerivation rec {
  pname = "picolisp";
  version = "24.6";

  src = fetchurl {
    url = "https://software-lab.de/picoLisp-${version}.tgz";
    hash = "sha256-kSJFoaR3FMa/fkVvEZJywN0fryY7Vc7BzCPaO1sKAiI=";
  };

  nativeBuildInputs = [
    llvm
    pkg-config
  ];

  buildInputs = [
    libffi
    openssl
    readline
  ];

  buildPhase = ''
    runHook preBuild
    (cd src && make)
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -m 555 -Dt $out/bin bin/*
    install -m 444 -Dt $out/lib/picolisp ./{ext,lib}.l
    cp -r lib $out/lib/picolisp
    cp -r man $out
    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace $out/bin/{pil,vip} \
      --replace-fail '/usr/bin' $out/bin --replace-fail '/usr/lib' $out/lib
    substituteInPlace $out/bin/{psh,pty,watchdog} \
      --replace-fail '/usr/bin' $out/bin
    ln -sf $out/bin $out/lib/picolisp/bin
  '';

  meta = {
    description = "Pragmatic Lisp dialect";
    homepage = "https://picolisp.com";
    mainProgram = "pil";
    maintainers = [ lib.maintainers.casaca ];
    platforms = lib.platforms.x86_64;
    license = with lib.licenses; [
      mit
      x11
    ];
  };
}
