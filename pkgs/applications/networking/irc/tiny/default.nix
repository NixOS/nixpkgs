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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "osa1";
    repo = pname;
    rev = "v${version}";
    sha256 = "177d1x4z0mh0p7c5ldq70cn1j3pac50d8cil2ni50hl49c3x6yy1";
  };

  cargoSha256 = "05q3f1wp48mwkz8n0102rwb6jzrgpx3dlbxzf3zcw8r1mblgzim1";

  cargoBuildFlags = lib.optionals stdenv.isLinux [ "--features=desktop-notifications" ];

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs = lib.optionals stdenv.isLinux [ dbus openssl ] ++ lib.optional stdenv.isDarwin Foundation;

  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    changelog = "https://github.com/osa1/tiny/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne vyp ];
  };
}
