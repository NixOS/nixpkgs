{
  lib,
  stdenv,
  fetchurl,

  lsb-release,
  which,
  pkg-config,
  gtk3,
  fontconfig,
  ftgl,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "canvasdraw";
  version = "5.14";

  src = fetchurl {
    url = "mirror://sourceforge/canvasdraw/${version}/Docs%20and%20Sources/cd-${version}_Sources.tar.gz";
    hash = "sha256-xE7cBBExyaakKTPIeaZE1r2CjWCyikuFWpzeYV/Fr08=";
  };

  nativeBuildInputs = [
    lsb-release
    which
    pkg-config
  ];

  buildInputs = [
    gtk3
    fontconfig
    ftgl
    libGLU
  ];

  sourceRoot = "cd/src";

  makeFlags = [
    "USE_PKGCONFIG=Yes"
    "USE_GTK3=Yes"
    "cd"
    "cdgl"
    "cdcontextplus"
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -d "$out/lib"
    install -m644 ../lib/*/lib*.so "$out/lib"
    install -m755 -d "$out/include"
    install -m644 ../include/* "$out/include"
    runHook postInstall
  '';

  meta = {
    description = "C platform-independent graphics library, aka canvasdraw";
    homepage = "http://www.tecgraf.puc-rio.br/cd/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ saturn745 ];
    platforms = lib.platforms.linux;
  };
}
