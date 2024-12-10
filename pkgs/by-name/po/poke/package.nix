{
  lib,
  stdenv,
  fetchurl,
  help2man,
  pkg-config,
  texinfo,
  boehmgc,
  readline,
  nbdSupport ? !stdenv.hostPlatform.isDarwin,
  libnbd,
  textStylingSupport ? true,
  gettext,
  dejagnu,

  # update script only
  writeScript,
}:

let
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "poke";
  version = "4.2";

  src = fetchurl {
    url = "mirror://gnu/poke/poke-${finalAttrs.version}.tar.gz";
    hash = "sha256-iq825h42elMUDqQOJVnp7FEud5xCvuNOesJLNLoRm94=";
  };

  outputs =
    [
      "out"
      "dev"
      "info"
      "lib"
    ]
    # help2man can't cross compile because it runs `poke --help` to
    # generate the man page
    ++ lib.optional (!isCross) "man";

  postPatch = ''
    patchShebangs .
  '';

  strictDeps = true;

  nativeBuildInputs =
    [
      pkg-config
      texinfo
    ]
    ++ lib.optionals (!isCross) [
      help2man
    ];

  buildInputs =
    [
      boehmgc
      readline
    ]
    ++ lib.optional nbdSupport libnbd
    ++ lib.optional textStylingSupport gettext
    ++ lib.optional finalAttrs.finalPackage.doCheck dejagnu;

  configureFlags = [
    # libpoke depends on $datadir/poke, so we specify the datadir in
    # $lib, and later move anything else it doesn't depend on to $out
    "--datadir=${placeholder "lib"}/share"
  ];

  enableParallelBuilding = true;

  doCheck = true;
  nativeCheckInputs = [ dejagnu ];

  postInstall = ''
    moveToOutput share/emacs "$out"
    moveToOutput share/vim "$out"
  '';

  passthru = {
    updateScript = writeScript "update-poke" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of '<a href="...">poke 2.0</a>'
      new_version="$(curl -s https://www.jemarch.net/poke |
          pcregrep -o1 '>poke ([0-9.]+)</a>')"
      update-source-version poke "$new_version"
    '';
  };

  meta = {
    description = "Interactive, extensible editor for binary data";
    homepage = "http://www.jemarch.net/poke";
    changelog = "https://git.savannah.gnu.org/cgit/poke.git/plain/ChangeLog?h=releases/poke-${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      AndersonTorres
      kira-bruneau
    ];
    platforms = lib.platforms.unix;
    hydraPlatforms = lib.platforms.linux; # build hangs on Darwin platforms, needs investigation
  };
})
