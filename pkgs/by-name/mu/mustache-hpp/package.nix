{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mustache";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "kainjow";
    repo = "Mustache";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a9EN3cQFyLWjnHCAC9xsY/sFJxVTu6qjaPTysM1cOWU=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include
    cp mustache.hpp $out/include
  '';

  meta = {
    description = "Mustache text templates for modern C++";
    homepage = "https://github.com/kainjow/Mustache";
    license = lib.licenses.boost;
  };
})
