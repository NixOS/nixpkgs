{
  lib,
  stdenv,
  fetchurl,
  perl,
  bsd-finger,
  withAbook ? true,
  abook,
  withGnupg ? true,
  gnupg,
  withGoobook ? true,
  goobook,
  withKhard ? true,
  khard,
  withMu ? true,
  mu,
}:

let
  perl' = perl.withPackages (
    p: with p; [
      AuthenSASL
      ConvertASN1
      IOSocketSSL
      perlldap
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lbdb";
  version = "0.57";

  src = fetchurl {
    url = "https://www.spinnaker.de/lbdb/download/lbdb-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-IS/i5A317T5Ulrxegh5LBoOmyVI7iIXn6HtjS8+SOog=";
  };

  buildInputs = [
    perl'
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) bsd-finger
  ++ lib.optional withAbook abook
  ++ lib.optional withGnupg gnupg
  ++ lib.optional withGoobook goobook
  ++ lib.optional withKhard khard
  ++ lib.optional withMu mu;

  configureFlags =
    [ ]
    ++ lib.optional withAbook "--with-abook"
    ++ lib.optional withGnupg "--with-gpg"
    ++ lib.optional withGoobook "--with-goobook"
    ++ lib.optional withKhard "--with-khard"
    ++ lib.optional withMu "--with-mu";

  patches = [
    ./add-methods-to-rc.patch
  ];

  meta = {
    homepage = "https://www.spinnaker.de/lbdb/";
    description = "Little Brother's Database";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      kaiha
      bfortz
    ];
    platforms = lib.platforms.all;
  };
})
