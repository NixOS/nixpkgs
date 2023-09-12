{ lib
, appimageTools
, fetchurl
}:

appimageTools.wrapType2 rec {
  pname = "bazecor";
  version = "1.3.2";

  src = fetchurl {
    url = "https://github.com/Dygmalab/Bazecor/releases/download/bazecor-${version}/Bazecor-${version}-x64.AppImage";
    hash = "sha256-afalUj3EqHX6ctCZgwGRf4kqv9AeVS+PAaBA4iK9jKk=";
  };

  meta = with lib; {
    description = "Graphical configurator for Dygma Products";
    homepage = "https://github.com/Dygmalab/Bazecor";
    changelog = "https://github.com/Dygmalab/Bazecor/releases/tag/bazecor-${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kashw2 ];
  };
}
