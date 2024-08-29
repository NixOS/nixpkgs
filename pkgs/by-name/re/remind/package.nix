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
  version = "05.00.02";

  src = fetchurl {
    url = "https://dianne.skoll.ca/projects/remind/download/remind-${version}.tar.gz";
    hash = "sha256-XxVjAV3TGDPI8XaFXXSminsMffq8m8ljw68YMIC2lYg=";
  };

  propagatedBuildInputs = lib.optionals withGui [
    tcllib
    tk
  ];

  postPatch = lib.optionalString withGui ''
    # NOTA BENE: The path to rem2pdf is replaced in tkremind for future use
    # as rem2pdf is currently not build since it requires the JSON::MaybeXS,
    # Pango and Cairo Perl modules.
    substituteInPlace scripts/tkremind \
      --replace-fail "exec wish" "exec ${lib.getExe' tk "wish"}" \
      --replace-fail 'set Remind "remind"' "set Remind \"$out/bin/remind\"" \
      --replace-fail 'set Rem2PS "rem2ps"' "set Rem2PS \"$out/bin/rem2ps\"" \
      --replace-fail 'set Rem2PDF "rem2pdf"' "set Rem2PDF \"$out/bin/rem2pdf\""
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin (toString [
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
