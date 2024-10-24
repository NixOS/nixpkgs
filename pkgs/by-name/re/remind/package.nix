{
  lib,
  stdenv,
  fetchurl,
  tk,
  tcllib,
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
  version = "05.00.07";

  src = fetchurl {
    url = "https://dianne.skoll.ca/projects/remind/download/remind-${version}.tar.gz";
    hash = "sha256-id3yVyKHRSJWhm8r4Zmc/k61AZUt1wa3lArQktDbt9w=";
  };

  propagatedBuildInputs = lib.optionals withGui [
    tcllib
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
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin (toString [
    # On Darwin setenv and unsetenv are defined in stdlib.h from libSystem
    "-DHAVE_SETENV"
    "-DHAVE_UNSETENV"
  ]);

  meta = with lib; {
    homepage = "https://dianne.skoll.ca/projects/remind/";
    description = "Sophisticated calendar and alarm program for the console";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      raskin
      kovirobi
    ];
    mainProgram = "remind";
    platforms = platforms.unix;
  };
}
