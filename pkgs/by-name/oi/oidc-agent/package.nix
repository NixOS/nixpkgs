{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  webkitgtk,
  libmicrohttpd,
  libsecret,
  qrencode,
  libsodium,
  pkg-config,
  help2man,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "oidc-agent";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "indigo-dc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OW0hCDVC+AqmXP1dQK/7lnXeG8RbXzFLbKLEvc/8spY=";
  };

  nativeBuildInputs = [
    pkg-config
    help2man
  ];

  buildInputs = [
    curl
    webkitgtk
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
  ];

  installTargets = [
    "install_bin"
    "install_lib"
    "install_conf"
  ];

  postFixup = ''
    # Override with patched binary to be used by help2man
    cp -r $out/bin/* bin
    make install_man PREFIX=$out MAN_PATH=$out/share/man PROMPT_MAN_PATH=$out/share/man
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Manage OpenID Connect tokens on the command line";
    homepage = "https://github.com/indigo-dc/oidc-agent";
    maintainers = with maintainers; [ xinyangli ];
    license = licenses.mit;
  };
}
