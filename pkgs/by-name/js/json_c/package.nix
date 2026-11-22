{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "json-c";
  version = "0.19";

  src = fetchFromGitHub {
    owner = "json-c";
    repo = "json-c";
    tag = "json-c-0.19-20260627";
    hash = "sha256-ZfwVOU6PJKHSj7XVZh5BUb3VJ+lHXZVMPdHh5fgrock=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_APPS" false)
  ];

  __structuredAttrs = true;

  meta = {
    description = "JSON implementation in C";
    longDescription = ''
      JSON-C implements a reference counting object model that allows you to
      easily construct JSON objects in C, output them as JSON formatted strings
      and parse JSON formatted strings back into the C representation of JSON
      objects.
    '';
    homepage = "https://github.com/json-c/json-c/wiki";
    changelog = "https://github.com/json-c/json-c/blob/${finalAttrs.src.rev}/ChangeLog";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
})
