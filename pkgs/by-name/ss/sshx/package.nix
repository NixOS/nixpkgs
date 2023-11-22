{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, protobuf
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sshx";
  version = "unstable-2023-11-04";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "sshx";
    rev = "91c82d46cde4d1ffa0ae34e2a9a49911e2e53baa";
    hash = "sha256-X9c7ZKIpWI5EsbkgB8FJWlwQQXHAcPjLKp2Bvo0fo/w=";
  };

  cargoHash = "sha256-mOK5gpPuUKzN5xnJs5nFyslxr9IIHtiCylMP53ObDqg=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  outputs = [ "out" "server" ];

  postInstall = ''
    moveToOutput 'bin/sshx' "$out"
    moveToOutput 'bin/sshx-server' "$server"
  '';

  meta = with lib; {
    description = "Fast, collaborative live terminal sharing over the web";
    homepage = "https://github.com/ekzhang/sshx";
    license = licenses.mit;
    maintainers = with maintainers; [ pinpox ];
    mainProgram = "sshx";
  };
}
