{
  lib,
  stdenv,
  sfml_2,
  fetchFromGitHub,
  libXi,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit (sfml_2) pname;
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "SFML";
    tag = finalAttrs.version;
    hash = "sha256-e6x/L2D3eT6F/DBLQDZ+j0XD5NL9RalWZA8kcm9lZ3g=";
  };

  inherit (sfml_2) nativeBuildInputs cmakeFlags;
  buildInputs = [
    libXi
  ] ++ sfml_2.buildInputs;

  meta = {
    inherit (sfml_2.meta)
      description
      homepage
      longDescription
      license
      platforms
      ;
    changelog = "https://github.com/SFML/SFML/blob/${finalAttrs.version}/changelog.md";
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
