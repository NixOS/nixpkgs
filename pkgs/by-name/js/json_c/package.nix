{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "json-c";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "json-c";
    repo = "json-c";
    rev = "json-c-0.18-20240915";
    hash = "sha256-UyMXr8Vc6kDOx1/lD2YKPiHdaTotXAF9ak0yQuwrSUA=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "JSON implementation in C";
    longDescription = ''
      JSON-C implements a reference counting object model that allows you to
      easily construct JSON objects in C, output them as JSON formatted strings
      and parse JSON formatted strings back into the C representation of JSON
      objects.
    '';
    homepage = "https://github.com/json-c/json-c/wiki";
    changelog = "https://github.com/json-c/json-c/blob/${finalAttrs.src.rev}/ChangeLog";
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
})
