{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  libx11,
  libxext,
}:

stdenv.mkDerivation {
  pname = "kegs";
  version = "0.91-unstable-2011-10-18";

  src = fetchFromGitHub {
    owner = "aufflick";
    repo = "kegs";
    rev = "dc8899440147204b0e4ab99731cc56796eb6fdc3";
    hash = "sha256-ie+r0hx4DombqZxvaq5FbrwVfOA+i0CjKa8nnV39BCE=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [ perl ];

  buildInputs = [
    libx11
    libxext
  ];

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    ln -sf vars_x86linux vars
    substituteInPlace vars_x86linux \
      --replace-fail "CC = cc" "CC = $CC" \
      --replace-fail "PERL = perl" "PERL = ${lib.getExe perl}" \
      --replace-fail "-march=pentium" "" \
      --replace-fail "XOPTS = -I/usr/X11R6/include" "XOPTS ="
    substituteInPlace Makefile \
      --replace-fail "XLIBS = -L/usr/X11R6/lib" "XLIBS =" \
      --replace-fail "mv xkegs .." ""
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 xkegs "$out/bin/xkegs"
    install -Dm644 ../README.md "$out/share/doc/kegs/README.md"
    install -Dm644 ../README.compile.txt "$out/share/doc/kegs/README.compile.txt"
    install -Dm644 ../README.a2.compatibility.txt "$out/share/doc/kegs/README.a2.compatibility.txt"

    runHook postInstall
  '';

  meta = {
    description = "Apple IIgs emulator";
    homepage = "https://github.com/aufflick/kegs";
    license = lib.licenses.gpl2Only;
    mainProgram = "xkegs";
    maintainers = with lib.maintainers; [ kaistarkk ];
    platforms = lib.platforms.linux;
    badPlatforms = lib.platforms.bigEndian;
  };
}
