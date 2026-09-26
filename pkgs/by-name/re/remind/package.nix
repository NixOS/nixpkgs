{
  lib,
  stdenv,
  fetchzip,
  gitUpdater,
  bashNonInteractive,
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

tcl.mkTclDerivation (finalAttrs: {
  pname = "remind";
  version = "06.02.10";

  src = fetchzip {
    url = "https://dianne.skoll.ca/projects/remind/download/remind-${finalAttrs.version}.tar.gz";
    hash = "sha256-R6kceXLzg5CRMYAgMyhnmKxWT49ayXIFm/IpXuDgl8I=";
  };

  buildInputs = [
    bashNonInteractive
  ];

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
      --replace-fail 'set Rem2PDF "rem2pdf"' "set Rem2PDF \"$out/bin/rem2pdf\""
  '';

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # On Darwin setenv and unsetenv are defined in stdlib.h from libSystem
    NIX_CFLAGS_COMPILE = toString [
      "-DHAVE_SETENV"
      "-DHAVE_UNSETENV"
    ];
  };

  passthru.updateScript = gitUpdater {
    ignoredVersions = "-BETA";
  };

  meta = {
    homepage = "https://dianne.skoll.ca/projects/remind/";
    description = "Sophisticated calendar and alarm program for the console";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      afh
      raskin
      kovirobi
    ];
    mainProgram = "remind";
    platforms = lib.platforms.unix;
  };
})
