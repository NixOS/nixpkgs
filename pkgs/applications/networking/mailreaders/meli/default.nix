{ stdenv
, lib
, fetchgit
, rustPlatform
, pkgconfig
, openssl
, dbus
, sqlite
, file
, gzip
, notmuch
  # Build with support for notmuch backend
, withNotmuch ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "alpha-0.6.2";

  src = fetchgit {
    url = "https://git.meli.delivery/meli/meli.git";
    rev = version;
    sha256 = "0ycyksrrp4llwklzx3ipac8hmpfxa1pa7dqsm82wic0f6p5d1dp6";
  };

  cargoSha256 = "sha256:0lxwhb2c16w5z7rqzch0ij8n8hxb5xcin31w9i28mzv1xm7sg8ks";

  cargoBuildFlags = lib.optional withNotmuch "--features=notmuch";

  nativeBuildInputs = [ pkgconfig gzip ];

  buildInputs = [ openssl dbus sqlite ] ++ lib.optional withNotmuch notmuch;

  checkInputs = [ file ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    gzip < docs/meli.1 > $out/share/man/man1/meli.1.gz
    mkdir -p $out/share/man/man5
    gzip < docs/meli.conf.5 > $out/share/man/man5/meli.conf.5.gz
    gzip < docs/meli-themes.5 > $out/share/man/man5/meli-themes.5.gz
  '';

  meta = with stdenv.lib; {
    description = "Experimental terminal mail client aiming for configurability and extensibility with sane defaults";
    homepage = "https://meli.delivery";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F matthiasbeyer erictapen ];
    platforms = platforms.linux;
  };
}
