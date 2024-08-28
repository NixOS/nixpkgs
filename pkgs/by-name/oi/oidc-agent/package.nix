{ lib
, stdenv
, fetchFromGitHub
, curl
, webkitgtk
, libmicrohttpd
, libsecret
, qrencode
, libsodium
, pkg-config
, help2man
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "oidc-agent";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "indigo-dc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cOK/rZ/jnyALLuhDM3+qvwwe4Fjkv8diQBkw7NfVo0c=";
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

  makeFlags = [ "PREFIX=$(out)" "BIN_PATH=$(out)" "LIB_PATH=$(out)/lib" ];

  installTargets = [ "install_bin" "install_lib" "install_conf" ];

  postFixup = ''
    # Override with patched binary to be used by help2man
    cp -r $out/bin/* bin
    make install_man PREFIX=$out
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Manage OpenID Connect tokens on the command line";
    homepage = "https://github.com/indigo-dc/oidc-agent";
    maintainers = with maintainers; [ xinyangli ];
    license = licenses.mit;
  };
}

