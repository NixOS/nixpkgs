{ stdenv
, lib
, fetchgit
, rustPlatform
, pkg-config
, openssl
, dbus
, sqlite
, file
, makeWrapper
, notmuch
  # Build with support for notmuch backend
, withNotmuch ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "meli";
  version = "alpha-0.7.2";

  src = fetchgit {
    url = "https://git.meli.delivery/meli/meli.git";
    rev = version;
    sha256 = "sha256-cbigEJhX6vL+gHa40cxplmPsDhsqujkzQxe0Dr6+SK0=";
  };

  cargoSha256 = "sha256-ZE653OtXyZ9454bKPApmuL2kVko/hGBWEAya1L1KIoc=";

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ openssl dbus sqlite ] ++ lib.optional withNotmuch notmuch;

  nativeCheckInputs = [ file ];

  buildFeatures = lib.optionals withNotmuch [ "notmuch" ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    gzip < docs/meli.1 > $out/share/man/man1/meli.1.gz
    mkdir -p $out/share/man/man5
    gzip < docs/meli.conf.5 > $out/share/man/man5/meli.conf.5.gz
    gzip < docs/meli-themes.5 > $out/share/man/man5/meli-themes.5.gz
  '' + lib.optionalString withNotmuch ''
    # Fixes this runtime error when meli is started with notmuch configured:
    # $ meli
    # libnotmuch5 was not found in your system. Make sure it is installed and
    # in the library paths.
    # notmuch is not a valid mail backend
    wrapProgram $out/bin/meli --set LD_LIBRARY_PATH ${notmuch}/lib
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Experimental terminal mail client aiming for configurability and extensibility with sane defaults";
    homepage = "https://meli.delivery";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F matthiasbeyer erictapen ];
    platforms = platforms.linux;
  };
}
