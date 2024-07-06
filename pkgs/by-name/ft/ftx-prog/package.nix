{ stdenv
, lib
, fetchFromGitHub
, libftdi
, libusb1
, pkg-config
}: stdenv.mkDerivation (finalAttrs: {

  pname = "ftx-prog";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "richardeoin";
    repo = "ftx-prog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wBOzsJ1XIkswuwuCwGQk2Q+RUsGe5EOlbAhcf0R7rfc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libftdi libusb1 ];

  installPhase = ''
    mkdir -p $out/bin
    mv ftx_prog $out/bin
  '';

  meta = with lib; {
    description = "A Linux command-line alternative to the FTDI FTProg utility for FTDI's FT-X series ";
    mainProgram = "ftx-prog";
    homepage = "https://github.com/richardeoin/ftx-prog";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.funkeleinhorn ];
  };
})
