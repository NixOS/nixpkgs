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
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "indigo-dc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SjpCD/x93kYB5759e/D0btLO48d6g4SkEUAX7PYfm2w=";
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

