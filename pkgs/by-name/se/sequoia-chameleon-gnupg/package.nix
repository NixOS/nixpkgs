{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  makeWrapper,
  nettle,
  openssl,
  sqlite,
  gnupg,
  execline,
  gnused,
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-chameleon-gnupg";
  version = "0.13.1";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-chameleon-gnupg";
    rev = "v${version}";
    hash = "sha256-K9aeWrqJGPx2RymCXWNdNUTXXtO4NNm6Rd3jz+YxEi0=";
  };

  cargoHash = "sha256-d+Ew05pYpUepqsYLTcI3j2qcplXn2hDACyzXXDx6hNg=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    nettle
    openssl
    sqlite
  ];

  postInstall = ''
    # Wrap to find gpg-agent from GnuPG.
    makeWrapper $out/bin/gpg-sq $out/bin/gpg \
      --suffix PATH : ${lib.makeBinPath [ gnupg ]}
    makeWrapper $out/bin/gpgv-sq $out/bin/gpgv \
      --suffix PATH : ${lib.makeBinPath [ gnupg ]}

    # Modify the output of gpgconf to resolve gpg to this package.
    substitute ${./gpgconf.el} $out/bin/gpgconf \
      --subst-var-by execlineb ${lib.getExe' execline "execlineb"} \
      --subst-var-by gpgconf ${lib.getExe' gnupg "gpgconf"} \
      --subst-var-by sed ${lib.getExe' gnused "sed"} \
      --subst-var out

    # Additional wrappers.
    chmod +x $out/bin/gpgconf
    ln -s gpg $out/bin/gpg2
    ln -s ${lib.getExe' gnupg "gpg"} $out/bin/gpg-g10code
  '';

  # gpgconf: error creating socket directory
  doCheck = false;

  meta = {
    description = "Sequoia's reimplementation of the GnuPG interface";
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "gpg-sq";
  };
}
