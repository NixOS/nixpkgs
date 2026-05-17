{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  readline,
  bison,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "es";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "wryun";
    repo = "es-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rm0hG3B93p1lFb6IlnKYXtSxuRSIa2AT3SiAjMSb/oc=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    bison
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
