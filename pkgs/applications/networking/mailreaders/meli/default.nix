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
  version = "alpha-0.5.1";

  src = fetchgit {
    url = "https://git.meli.delivery/meli/meli.git";
    rev = version;
    sha256 = "1y5567hdm1s2s272drxvmp6x4y1jpyl7423iz58hgqcsjm9085zv";
  };

  cargoSha256 = "040dfr09bg5z5pn68dy323hcppd599d3f6k7zxqw5f8n4whnlc9y";

  cargoBuildFlags = lib.optional withNotmuch "--features=notmuch";

  nativeBuildInputs = [ pkgconfig gzip ];

  buildInputs = [ openssl dbus sqlite ] ++ lib.optional withNotmuch notmuch;

  checkInputs = [ file ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    gzip < meli.1 > $out/share/man/man1/meli.1.gz
    mkdir -p $out/share/man/man5
    gzip < meli.conf.5 > $out/share/man/man5/meli.conf.5.gz
  '';

  meta = with stdenv.lib; {
    description = "Experimental terminal mail client aiming for configurability and extensibility with sane defaults";
    homepage = "https://meli.delivery";
    license = licenses.gpl3;
    maintainers = with maintainers; [ maintainers."0x4A6F" matthiasbeyer erictapen ];
    platforms = platforms.linux;
  };
}
