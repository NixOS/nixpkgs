{
  lib,
  stdenv,
  fetchFromGitea,
  gitUpdater,
  tk,
  tclPackages,
  tcl,
  tkremind ? null,
  withGui ?
    if tkremind != null then
      lib.warn "tkremind is deprecated and should be removed; use withGui instead." tkremind
    else
      true,
}:

tcl.mkTclDerivation rec {
  pname = "remind";
  version = "06.01.00";

  src = fetchFromGitea {
    domain = "git.skoll.ca";
    owner = "Skollsoft-Public";
    repo = "Remind";
    rev = version;
    hash = "sha256-1M1cKyonDydYl+UtScMwtp7DBQEFceaSXSUvMseKzzA=";
  };

  propagatedBuildInputs = lib.optionals withGui [
    tclPackages.tcllib
    tk
  ];

  postPatch = lib.optionalString withGui ''
    # NOTA BENE: The path to rem2pdf is replaced in tkremind for future use
    # as rem2pdf is currently not build since it requires the JSON::MaybeXS,
    # Pango and Cairo Perl modules.
    substituteInPlace scripts/tkremind.in \
      --replace-fail "exec wish" "exec ${lib.getExe' tk "wish"}" \
      --replace-fail 'set Remind "remind"' "set Remind \"$out/bin/remind\"" \
      --replace-fail 'set Rem2PS "rem2ps"' "set Rem2PS \"$out/bin/rem2ps\"" \
      --replace-fail 'set Rem2PDF "rem2pdf"' "set Rem2PDF \"$out/bin/rem2pdf\""
    substituteInPlace configure \
      --replace-fail 'f=-ffat-lto-objects' ""
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin (toString [
    # On Darwin setenv and unsetenv are defined in stdlib.h from libSystem
    "-DHAVE_SETENV"
    "-DHAVE_UNSETENV"
  ]);

  passthru.updateScript = gitUpdater {
    ignoredVersions = "-BETA";
  };

  meta = with lib; {
    homepage = "https://dianne.skoll.ca/projects/remind/";
    description = "Sophisticated calendar and alarm program for the console";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      afh
      raskin
      kovirobi
    ];
    mainProgram = "remind";
    platforms = platforms.unix;
  };
}
