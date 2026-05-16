{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  readline,
  bison,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "es";
  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/wryun/es-shell/releases/download/v${finalAttrs.version}/es-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-VR7Al0gi7Agee5+O55N0xidmym3NscaFqY79w+bbxLk=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    bison
    autoreconfHook
  ];
  buildInputs = [ readline ];

  configureFlags = [ "--with-readline" ];

  meta = {
    description = "Extensible shell with higher order functions";
    mainProgram = "es";
    longDescription = ''
      Es is an extensible shell. The language was derived
      from the Plan 9 shell, rc, and was influenced by
      functional programming languages, such as Scheme,
      and the Tcl embeddable programming language.
    '';
    homepage = "http://wryun.github.io/es-shell/";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [
      sjmackenzie
      ttuegel
    ];
    platforms = lib.platforms.all;
  };

  passthru = {
    shellPath = "/bin/es";
  };
})
