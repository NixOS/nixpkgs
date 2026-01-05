{
  clang,
  fetchurl,
  lib,
  libffi,
  llvm,
  makeWrapper,
  openssl,
  pkg-config,
  readline,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "PicoLisp";
  version = "24.3.30";
  src = fetchurl {
    url = "https://www.software-lab.de/picoLisp-24.3.tgz";
    sha256 = "sha256-FB43DAjHBFgxdysoLzBXLxii52a2CCh1skZP/RTzfdc=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    clang
    libffi
    llvm
    openssl
    readline
  ];
  sourceRoot = ''pil21'';
  preBuild = ''
    cd src
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Flags taken from instructions at: https://picolisp.com/wiki/?alternativeMacOSRepository
    makeFlagsArray+=(
      SHARED='-dynamiclib -undefined dynamic_lookup'
    )
  '';

  installPhase = ''
    cd ..
    mkdir -p "$out/lib" "$out/bin" "$out/man"
    cp -r . "$out/lib/picolisp/"
    ln -s "$out/lib/picolisp/bin/picolisp" "$out/bin/picolisp"
    ln -s "$out/lib/picolisp/bin/pil" "$out/bin/pil"
    ln -s "$out/lib/picolisp/man/man1/pil.1" "$out/man/pil.1"
    ln -s "$out/lib/picolisp/man/man1/picolisp.1" "$out/man/picolisp.1"
    substituteInPlace $out/bin/pil --replace-fail /usr $out
  '';

  meta = with lib; {
    description = "Pragmatic programming language";
    homepage = "https://picolisp.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ nat-418 ];
    platforms = platforms.all;
  };
}
