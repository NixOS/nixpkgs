{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # json_object_put() frees containers inside assert(), so NDEBUG builds
    # leak every non-empty object/array. Remove with the next release.
    # https://github.com/json-c/json-c/pull/936
    (fetchpatch {
      url = "https://github.com/json-c/json-c/commit/f291fa81c6f21d925ea771a8cca597f5886309cc.patch";
      hash = "sha256-ZffSw1pfEfOH2ylRpJShdx7sTQR2nmPM/JIj/26UrDM=";
    })
  ];

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
