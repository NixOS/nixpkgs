{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  xxd,
  meson,
  ninja,
  ncurses,
  argtable,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astroterm";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "da-luce";
    repo = "astroterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BjqurPp0WI/wI5n2TibnyOqZ3NjRcLYB2MxqqNvTQtw=";
  };

  bsc5File = fetchurl {
    url = "https://web.archive.org/web/20231007085824/http://tdc-www.harvard.edu/catalogs/BSC5";
    hash = "sha256-5HHQLq9O7LYcEvh5octkMrqde2ipqMVlSh60KgyMw0A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    xxd
  ];
  buildInputs = [
    argtable
    ncurses
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  postPatch = ''
    mkdir -p data
    ln -s ${finalAttrs.bsc5File} data/bsc5
  '';

  doCheck = true;

  meta = {
    description = "Celestial viewer for the terminal, written in C";
    homepage = "https://github.com/da-luce/astroterm/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.da-luce ];
    mainProgram = "astroterm";
    platforms = lib.platforms.unix;
  };
})
