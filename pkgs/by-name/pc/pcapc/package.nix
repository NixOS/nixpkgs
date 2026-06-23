{
  lib,
  stdenv,
  fetchFromCodeberg,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcapc";
  version = "1.0.1";

  src = fetchFromCodeberg {
    owner = "post-factum";
    repo = "pcapc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oDg9OSvi9aQsZ2SQm02NKAcppE0w5SGZaI13gdp7gv4=";
  };

  buildInputs = [ libpcap ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://gitlab.com/post-factum/pcapc";
    description = "Compile libpcap filter expressions into BPF opcodes";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "pcapc";
  };
})
