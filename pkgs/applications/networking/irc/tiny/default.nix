{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, openssl
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "osa1";
    repo = pname;
    rev = "v${version}";
    sha256 = "gKyHR3FZHDybaP38rqB8/gvr8T+mDO4QQxoTtWS+TlE=";
  };

  cargoSha256 = "0ChfW8vaqC2kCp4lpS0HOvhuihPw9G5TOmgwKzVDfws=";

  # Fix Cargo.lock version. Remove with the next release.
  cargoPatches = [
    ./fix-Cargo.lock.patch
  ];

  cargoBuildFlags = lib.optionals stdenv.isLinux [ "--features=desktop-notifications" ];

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs = lib.optionals stdenv.isLinux [ dbus openssl ] ++ lib.optional stdenv.isDarwin Foundation;

  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    changelog = "https://github.com/osa1/tiny/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne vyp ];
  };
}
