{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  tpm2-tss,
  keyutils,
  asciidoc,
  libxslt,
  docbook_xsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ima-evm-utils";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "linux-integrity";
    repo = "ima-evm-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IAd5tqZjo9G8bZAAxo4nQ7j6kc0aHrTXmaL+LZfJUYM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    asciidoc
    libxslt
  ];

  buildInputs = [
    keyutils
    openssl
    tpm2-tss
  ];

  env.MANPAGE_DOCBOOK_XSL = "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  meta = {
    description = "Utility to manage digital signatures of the Linux kernel integrity subsystem (IMA/EVM)";
    mainProgram = "evmctl";
    homepage = "https://github.com/linux-integrity/ima-evm-utils";
    license = with lib.licenses; [
      lgpl2Plus # libimaevm
      gpl2Plus # evmctl
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
