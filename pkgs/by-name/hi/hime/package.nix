{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  gtk2,
  gtk3,
  qt5,
  libXtst,
  lib,
  libchewing,
  unixtools,
  anthy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hime";
  version = "0.9.11";

  src = fetchFromGitHub {
    repo = "hime";
    owner = "hime-ime";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fCqet+foQjI+LpTQ/6Egup1GzXELlL2hgbh0dCKLwPI=";
  };

  nativeBuildInputs = [
    which
    pkg-config
    unixtools.whereis
  ];
  buildInputs = [
    libXtst
    gtk2
    gtk3
    qt5.qtbase
    libchewing
    anthy
  ];

  preConfigure = "patchShebangs configure";
  configureFlags = [
    "--disable-lib64"
    "--disable-qt5-immodule"
  ];
  dontWrapQtApps = true;
  postFixup = ''
    hime_rpath=$(patchelf --print-rpath $out/bin/hime)
    patchelf --set-rpath $out/lib/hime:$hime_rpath $out/bin/hime
  '';

  meta = {
    homepage = "http://hime-ime.github.io/";
    downloadPage = "https://github.com/hime-ime/hime/downloads";
    description = "Useful input method engine for Asia region";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yanganto ];
  };
})
