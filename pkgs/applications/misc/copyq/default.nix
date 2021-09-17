{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtbase
, qtscript
, libXfixes
, libXtst
, qtx11extras
, git
, knotifications
, qtwayland
, wayland
, fetchpatch
}:

mkDerivation rec {
  pname = "CopyQ";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    sha256 = "1iacnd9dn0mrajff80r2g5nlks5sch9lmpl633mnyqmih9dwx2li";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase
    qtscript
    libXfixes
    libXtst
    qtx11extras
    knotifications
    qtwayland
    wayland
  ];

  patches = [
    # Install the bash completion script correctly
    # Remove once 4.1.1 is released
    (fetchpatch {
      url = "https://github.com/hluk/CopyQ/commit/aca7222ec28589af0b08f63686104b992d63ee42.patch";
      sha256 = "0d440d0zsdzm9cd0b6c42y9qbrvxg7gdam0qmif62mr8qa0ylidl";
    })
  ];

  postPatch = ''
    substituteInPlace shared/com.github.hluk.copyq.desktop.in \
      --replace copyq "$out/bin/copyq"
  '';

  meta = with lib; {
    homepage = "https://hluk.github.io/CopyQ";
    description = "Clipboard Manager with Advanced Features";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ willtim artturin ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    # OSX build requires QT5.
    platforms = platforms.linux;
  };
}
