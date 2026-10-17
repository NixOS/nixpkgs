{
  lib,
  stdenv,
  fetchurl,
  db,
  flex,
  gnugrep,
  makeWrapper,
  pax,
  perl,
  valgrind,
  database ? db,
}:

let
  dbName = lib.getName database;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bogofilter-${dbName}";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/bogofilter/bogofilter-${finalAttrs.version}.tar.xz";
    hash = "sha256-MkihNzv/VSxQCDStvqS2yu4EIkUWrlgfslpMam3uieo=";
  };

  # bogofilter's test-cases hard-code the search path for grep.
  postPatch = ''
    substituteInPlace ./src/tests/t.frame \
      --replace-fail 'GREP=/bin/grep' 'GREP=${lib.getExe gnugrep}'
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    flex
    database
  ]
  ++ lib.optional (dbName == "db") perl; # required by bogoupgrade

  configureFlags = [
    "--with-database=${dbName}"
  ];

  nativeCheckInputs = [
    valgrind
  ];

  doCheck = true;
  checkFlags = [
    "BF_RUN_VALGRIND=1"
    "BF_CHECKTOOL=glibc"
    "VERBOSE=-x"
  ];

  postInstall = ''
    wrapProgram "$out/bin/bf_tar" --prefix PATH : "${lib.makeBinPath [ pax ]}"
  ''
  # Only supports upgrading through various db versions, not useful for
  # other database types.
  + lib.optionalString (dbName != "db") ''
    rm "$out/bin/bogoupgrade"
  '';

  meta = {
    homepage = "http://bogofilter.sourceforge.net/";
    longDescription = ''
      Bogofilter is a mail filter that classifies mail as spam or ham
      (non-spam) by a statistical analysis of the message's header and
      content (body).  The program is able to learn from the user's
      classifications and corrections.  It is based on a Bayesian
      filter.
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "bogofilter";
    maintainers = with lib.maintainers; [ Stebalien ];
    platforms = lib.platforms.linux;
  };
})
