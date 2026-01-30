{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  imlib2,
  libX11,
  libXinerama,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hsetroot";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "himdel";
    repo = "hsetroot";
    rev = finalAttrs.version;
    sha256 = "1jbk5hlxm48zmjzkaq5946s58rqwg1v1ds2sdyd2ba029hmvr722";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    imlib2
    libX11
    libXinerama
  ];

  postPatch = lib.optionalString (!stdenv.cc.isGNU) ''
    sed -i -e '/--no-as-needed/d' Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  meta = {
    description = "Allows you to compose wallpapers ('root pixmaps') for X";
    homepage = "https://github.com/himdel/hsetroot";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
