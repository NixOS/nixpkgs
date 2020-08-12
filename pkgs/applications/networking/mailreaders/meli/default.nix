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
  version = "alpha-0.6.1";

  src = fetchgit {
    url = "https://git.meli.delivery/meli/meli.git";
    rev = version;
    sha256 = "0fs3wccbdfxf4nmx9l5wy7qpjk4r11qg0fc59y0pdvjrrslcjsds";
  };

  cargoSha256 = "sha256:19j7jrizp7yifmqwrmnv66pka7131jl7ks4zgs3nr5gbb28zvdrz";

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
