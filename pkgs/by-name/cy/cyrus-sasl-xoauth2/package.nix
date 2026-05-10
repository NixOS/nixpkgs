{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  libtool,
  automake,
  cyrus_sasl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cyrus-sasl-xoauth2";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "moriyoshi";
    repo = "cyrus-sasl-xoauth2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-lI8uKtVxrziQ8q/Ss+QTgg1xTObZUTAzjL3MYmtwyd8=";
  };

  nativeBuildInputs = [
    autoconf
    libtool
    automake
  ];

  buildInputs = [ cyrus_sasl ];

  preConfigure = "./autogen.sh";

  configureFlags = [
    "--with-cyrus-sasl=${placeholder "out"}"
  ];

  meta = {
    homepage = "https://github.com/moriyoshi/cyrus-sasl-xoauth2";
    description = "XOAUTH2 mechanism plugin for cyrus-sasl";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wentasah ];
  };
})
