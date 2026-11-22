{
  fetchurl,
  lib,
  stdenv,
  guile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcron";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://gnu/mcron/mcron-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-G8jA02LTsaMPoAcdf6tpa7/B2h7VNsQuBIC7n/0iFU4=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./mac-username.patch
  ];

  # Setuid is not usable from the Nix store; also drop -static on the
  # crontab-access helper (needs a static libc, fails on Darwin).
  postPatch = ''
    sed -E -i '/chmod u\+s/d' Makefile.in
    substituteInPlace Makefile.in \
      --replace-fail 'bin_crontab_access_LDFLAGS = -static' 'bin_crontab_access_LDFLAGS ='
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ guile ];

  doCheck = true;

  meta = {
    description = "Flexible implementation of `cron' in Guile";

    longDescription = ''
      The GNU package mcron (Mellor's cron) is a 100% compatible
      replacement for Vixie cron.  It is written in pure Guile, and
      allows configuration files to be written in scheme (as well as
      Vixie's original format) for infinite flexibility in specifying
      when jobs should be run.  Mcron was written by Dale Mellor.
    '';

    homepage = "https://www.gnu.org/software/mcron/";

    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
