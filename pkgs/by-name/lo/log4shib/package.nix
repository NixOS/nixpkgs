{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "log4shib";
  version = "2.0.1";

  src = fetchFromCodeberg {
    owner = "Shibboleth";
    repo = "cpp-log4shib";
    tag = finalAttrs.version;
    hash = "sha256-EoVg+u8t8h8HZrXHg+854+Az0tN9shPPyl6oTSjKqYg=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Forked version of log4cpp that has been created for the Shibboleth project";
    maintainers = with lib.maintainers; [ drawbu ];
    license = lib.licenses.lgpl21;
    homepage = "http://log4cpp.sf.net";
  };
})
