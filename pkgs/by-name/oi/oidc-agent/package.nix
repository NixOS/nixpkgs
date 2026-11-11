{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  curl,
  webkitgtk_4_1,
  libmicrohttpd,
  libsecret,
  qrencode,
  libsodium,
  pkg-config,
  help2man,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oidc-agent";
  version = "5.3.8";

  src = fetchFromGitHub {
    owner = "indigo-dc";
    repo = "oidc-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n88PQgFqsYiFwngaz1LGicVszoiepafshZa5/DiNw3I=";
  };

  patches = [
    # Proposed to upstream https://github.com/indigo-dc/oidc-agent/pull/671
    (fetchpatch {
      name = "crypt-stdio.patch";
      url = "https://github.com/indigo-dc/oidc-agent/commit/50c0c44815f0ca0076148de6f0034e4dc5ba4f5c.patch?full_index=1";
      hash = "sha256-R7w+SvoVDD/OiGlhQxAiV5BUaEAxEUCGg6pE/0kzHhk=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    help2man
  ];

  buildInputs = [
    curl
    webkitgtk_4_1
    libmicrohttpd
    libsecret
    qrencode
    libsodium
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=$(out)"
    "BIN_PATH=$(out)"
    "PROMPT_BIN_PATH=$(out)"
    "LIB_PATH=$(out)/lib"
    "WEBKITGTK=webkit2gtk-4.1"
  ];

  installTargets = [
    "install_bin"
    "install_lib"
    "install_conf"
  ];

  postFixup = ''
    # Override with patched binary to be used by help2man
    cp -r $out/bin/* bin
    make install_man PREFIX=$out MAN_PATH=$out/share/man PROMPT_MAN_PATH=$out/share/man WEBKITGTK=webkit2gtk-4.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage OpenID Connect tokens on the command line";
    homepage = "https://github.com/indigo-dc/oidc-agent";
    maintainers = with lib.maintainers; [ xinyangli ];
    license = lib.licenses.mit;
  };
})
