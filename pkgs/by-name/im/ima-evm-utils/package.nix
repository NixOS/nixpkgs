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

stdenv.mkDerivation rec {
  pname = "ima-evm-utils";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "linux-integrity";
    repo = "ima-evm-utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-vIu12Flc2DiEqUSKAfoUi7Zg6D25pURvlYKEQKHER4I=";
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
    description = "evmctl utility to manage digital signatures of the Linux kernel integrity subsystem (IMA/EVM)";
    mainProgram = "evmctl";
    homepage = "https://github.com/linux-integrity/ima-evm-utils";
    license = with lib.licenses; [
      lgpl2Plus # libimaevm
      gpl2Plus # evmctl
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
