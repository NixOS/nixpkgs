{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, Security }:

rustPlatform.buildRustPackage rec {
  name = "synapse-bt-unstable-${version}";
  version = "2018-10-17";

  src = fetchFromGitHub {
    owner = "Luminarys";
    repo = "synapse";
    rev = "76d5e9a23ad00c25cfd0469b1adb479b9ded113a";
    sha256 = "1lsfvcsmbsg51v8c2hkpwkx0zg25sdjc3q7x72b5bwwnw9l0iglz";
  };

  cargoSha256 = "0ay6k52x6lzyvmzmlzrjfyqmify9wz74hxsdh8mhrhlpcvll17h1";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  cargoBuildFlags = [ "--all" ];

  meta = with stdenv.lib; {
    description = "Flexible and fast BitTorrent daemon";
    homepage = https://synapse-bt.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
