{ lib, stdenv, fetchFromGitHub, rofi, gnused }:

stdenv.mkDerivation rec {
  pname = "rofi-menugen";
  version = "unstable-2015-12-28";

  src = fetchFromGitHub {
    owner = "octotep";
    repo = "menugen";
    rev = "168efd2608fdb88b1aff3e0244bda8402169f207";
    sha256 = "09fk9i6crw772qlc5zld35pcff1jq4jcag0syial2q000fbpjx5m";
  };

  postPatch = ''
    sed -i -e "s|menugenbase|$out/bin/rofi-menugenbase|" menugen
    sed -i -e "s|rofi |${rofi}/bin/rofi |" menugen
    sed -i -e "s|sed |${gnused}/bin/sed |" menugenbase
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp menugen $out/bin/rofi-menugen
    cp menugenbase $out/bin/rofi-menugenbase
  '';

  meta = with lib; {
    description = "Generates menu based applications using rofi";
    homepage = "https://github.com/octotep/menugen";
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
