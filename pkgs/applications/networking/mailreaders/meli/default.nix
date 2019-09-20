{ stdenv, fetchgit, rustPlatform, pkgconfig, openssl, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "pre-alpha-0.3.2";

  src = fetchgit {
    url = "https://git.meli.delivery/meli/meli.git";
    rev = "${version}";
    sha256 = "1rw6vm00aihnikpsm72lrx3svng6jfkyznwjg5xs9ffnqvix6pih";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "sha256:0zlml5pf5cdckxqqv811m4h88m5yg8df62ssd71djl1cw9syz63x";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl dbus ];

  meta = with stdenv.lib; {
    description = "Experimental terminal mail client aiming for configurability and extensibility with sane defaults";
    homepage = "https://meli.delivery";
    license = licenses.gpl3;
    maintainers = with maintainers; [ "0x4A6F" matthiasbeyer ];
    platforms = platforms.linux;
  };
}
