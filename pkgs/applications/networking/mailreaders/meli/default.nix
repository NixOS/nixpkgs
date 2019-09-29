{ stdenv, fetchgit, rustPlatform, pkgconfig, openssl, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "pre-alpha-0.3.2";

  src = fetchgit {
    url = "https://git.meli.delivery/meli/meli.git";
    rev = "51bb50abf38b4a6fc16acdb350fa3a889c6330da";
    sha256 = "0d20ij8cqykpkvgxxg34hbpsprz0s0bhh5g8vqm68x11753qfhb7";
  };

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
