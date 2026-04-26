{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "log4shib";
  version = "1.0.9";

  src = fetchFromCodeberg {
    owner = "Shibboleth";
    repo = "cpp-log4shib";
    tag = finalAttrs.version;
    hash = "sha256-PcIkn8LuB4zdYiV0LDM+pzDxeWdS1PiXQox2bGhhORs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  env.CXXFLAGS = "-std=c++11";

  meta = {
    description = "Forked version of log4cpp that has been created for the Shibboleth project";
    mainProgram = "log4shib-config";
    maintainers = [ ];
    license = lib.licenses.lgpl21;
    homepage = "http://log4cpp.sf.net";
  };
})
