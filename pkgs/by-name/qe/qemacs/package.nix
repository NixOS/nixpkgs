{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  which,
  texi2html,
  enableX11 ? true,
  libX11,
  libXext,
  libXv,
  libpng,
}:

stdenv.mkDerivation {
  pname = "qemacs";
  version = "6.3.2";

  src = fetchFromGitHub {
    owner = "qemacs";
    repo = "qemacs";
    rev = "0e90c181078f3d85d0d44d985d541184223668e1";
    hash = "sha256-3kq89CoUi9ocR0q2SqYF8S/xNgBpInC4f2d/dJg/nEM=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace \
      '$(INSTALL) -m 755 -s' \
      '$(INSTALL) -m 755 -s --strip-program=${stdenv.cc.targetPrefix}strip'
  '';

  nativeBuildInputs = [
    which
    texi2html
  ];
  buildInputs = lib.optionals enableX11 [
    libpng
    libX11
    libXext
    libXv
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--cross-prefix=${stdenv.cc.targetPrefix}"
  ]
  ++ lib.optionals (!enableX11) [
    "--disable-x11"
  ];

  makeFlags = [
    # is actually used as BUILD_CC
    "HOST_CC=${buildPackages.stdenv.cc}/bin/cc"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preInstall = ''
    mkdir -p $out/bin $out/man
  '';

  meta = with lib; {
    homepage = "https://bellard.org/qemacs/";
    description = "Very small but powerful UNIX editor";
    license = licenses.mit;
    maintainers = with maintainers; [ iblech ];
  };
}
