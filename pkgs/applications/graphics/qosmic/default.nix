{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  qmake,
  wrapQtAppsHook,
  qtbase,
  pkg-config,
  lua,
  flam3,
  libxml2,
  libpng,
  libjpeg,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "qosmic";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "bitsed";
    repo = "qosmic";
    rev = "v${version}";
    sha256 = "13nw1mkdib14430r21mj352v62vi546vf184vyhxm7yjjygyra1w";
  };

  patches = [
    # Allow overriding PREFIX (to install to $out,
    # written while creating this derivation)
    # https://github.com/bitsed/qosmic/pull/39
    (fetchpatch {
      name = "allow-overriding-PREFIX.patch";
      url = "https://github.com/bitsed/qosmic/commit/77fb3a577b0710efae2a1d9ed97c26ae16f3a5ba.patch";
      sha256 = "0v9hj9s78cb6bg8ca0wjkbr3c7ml1n51n8h4a70zpzzgzz7rli5b";
    })
    # Fix QButtonGroup include errors with Qt 5.11:
    # Will be part of the next post-1.6.0 release
    (fetchpatch {
      name = "fix-class-QButtonGroup-include-errors-with-Qt-5.11.patch";
      url = "https://github.com/bitsed/qosmic/commit/3f6e1ea8d384a124dbc2d568171a4da798480752.patch";
      sha256 = "0bp6b759plkqs32nvfpkfvf3qqzc9716k3ycwnjvwabbvpg1xwbl";
    })
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace qosmic.pro \
      --replace "/share" "/Applications/qosmic.app/Contents/Resources" \
      --replace "/qosmic/scripts" "/scripts" \
      --replace "install_icons install_desktop" ""
  '';

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qtbase
    lua
    flam3
    libxml2
    libpng
    libjpeg
  ];

  qmakeFlags = [
    # Use pkg-config to correctly locate library paths
    "CONFIG+=link_pkgconfig"
  ];

  preInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv qosmic.app $out/Applications
  '';

  meta = with lib; {
    description = "A cosmic recursive flame fractal editor";
    mainProgram = "qosmic";
    homepage = "https://github.com/bitsed/qosmic";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.unix;
  };
}
