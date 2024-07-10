{ lib
, foomatic-db
, foomatic-db-nonfree
, buildEnv
, foomatic-db-engine
, stdenv
, cups-filters
, ghostscript
, netpbm
, perl
, psutils
, patchPpdFilesHook
, withNonfreeDb ? false  # include foomatic-db-nonfree ppd files
}:

let
  foomatic-db-packages = [ foomatic-db ] ++
    lib.lists.optional withNonfreeDb foomatic-db-nonfree;

  foomatic-db-combined = buildEnv {
    name = "foomatic-db-combined";
    paths = foomatic-db-packages;
    pathsToLink = [ "/share/foomatic" ];
    # `foomatic-db-combined` is a nativeBuildInput of `foomatic-db-ppds`.
    # The setup hook defined here helps scripts in
    # `foomatic-db-engine` to find the database.
    postBuild = ''
      mkdir -p "${placeholder "out"}"/{etc/cups,nix-support}
      cat  >> "${placeholder "out"}/nix-support/setup-hook"  << eof
      export FOOMATICDB="${placeholder "out"}/share/foomatic"
      eof
    '';
  };

  # the effective license is `free` if all database
  # packages have free licenses, `unfree` otherwise
  isFree = lib.trivial.pipe foomatic-db-packages [
    (lib.lists.map (lib.attrsets.attrByPath [ "meta" "license" ] lib.licenses.unfree))
    (lib.lists.all (lib.attrsets.attrByPath [ "free" ] true))
  ];
in

stdenv.mkDerivation {
  pname = "foomatic-db-ppds";
  # the effective version is simply the
  # highest version of all database packages
  version = lib.trivial.pipe foomatic-db-packages [
    (lib.lists.map (lib.attrsets.getAttr "version"))
    (lib.lists.sort lib.strings.versionOlder)
    lib.lists.reverseList
    lib.lists.head
  ];

  buildInputs = [
    cups-filters
    ghostscript
    netpbm
    perl
    psutils
  ];

  nativeBuildInputs = [
    foomatic-db-combined
    foomatic-db-engine
    patchPpdFilesHook
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "${placeholder "out"}/share/cups/model"
    foomatic-compiledb -j "$NIX_BUILD_CORES" -d "${placeholder "out"}/share/cups/model/foomatic-db-ppds"
    runHook postInstall
  '';

  # Comments indicate the respective
  # package the command is contained in.
  ppdFileCommands = [
    "cat" "echo"  # coreutils
    "foomatic-rip"  # cups-filters or foomatic-filters
    "gs"  # ghostscript
    "pnmflip" "pnmgamma" "pnmnoraw"  # netpbm
    "perl"  # perl
    "psresize"  # psutils
    # These commands aren't packaged yet.
    # ppd files using these likely won't work.
    #"c2050" "c2070" "cjet" "lm1100"
    #"pbm2l2030" "pbm2lwxl" "rastertophaser6100"
  ];

  # compress ppd files
  postFixup = ''
    echo 'compressing ppd files'
    find -H "${placeholder "out"}/share/cups/model/foomatic-db-ppds" -type f -iname '*.ppd' -print0  \
      | xargs -0r -n 64 -P "$NIX_BUILD_CORES" gzip -9n
  '';

  meta = {
    description = "OpenPrinting ppd files";
    homepage = "https://openprinting.github.io/projects/02-foomatic/";
    license = if isFree then lib.licenses.free else lib.licenses.unfree;
    maintainers = [ lib.maintainers.yarny ];
    # list printer manufacturers here so people
    # searching for ppd files can find this package
    longDescription = ''
      All PPD files available in
      OpenPrinting's Foomatic database.
      This package contains about 8,800 PPD files,
      for printers from
      Alps, Anitech, Apollo, Apple, Avery, Brother, Canon,
      Citizen, CItoh, Compaq, DEC, Dell, Dymo-CoStar, Epson,
      Fujitsu, FujiXerox, Generic, Genicom, Gestetner,
      Heidelberg, Hitachi, HP, IBM, Imagen, Imagistics,
      InfoPrint, Infotec, Kodak, KONICAMINOLTA, Kyocera, Lanier,
      Lexmark, Minolta, MinoltaQMS, Mitsubishi, NEC, NRG, Oce,
      Oki, Olivetti, Panasonic, PCPI, Pentax, QMS, Raven, Ricoh,
      Samsung, Savin, Seiko, Sharp, SiPix, Sony, Star, Tally,
      Tektronix, TexasInstruments, Toshiba, Xante and Xerox.
    '';
  };
}
