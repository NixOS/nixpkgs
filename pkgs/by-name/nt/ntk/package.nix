{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
  libjpeg,
  libxft,
  pkg-config,
  python3,
  wafHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntk";
  version = "1.3.1001";
  src = fetchFromGitHub {
    owner = "linuxaudio";
    repo = "ntk";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-NyEdg6e+9CI9V+TIgdpPyH1ei+Vq8pUxD3wPzWY5fEU=";
  };

  nativeBuildInputs = [
    pkg-config
    wafHook
  ];
  buildInputs = [
    cairo
    libjpeg
    libxft
    python3
  ];

  # NOTE: ntk provides its own waf script that is incompatible with new
  # python versions. If the script is not present, wafHook will install
  # a compatible version from nixpkgs.
  prePatch = ''
    rm waf
  '';

  meta = {
    description = "Fork of FLTK 1.3.0 with additional functionality";
    version = finalAttrs.version;
    homepage = "http://non.tuxfamily.org/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      magnetophon
      nico202
    ];
    platforms = lib.platforms.linux;
  };
})
