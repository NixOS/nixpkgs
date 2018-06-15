{ stdenv, fetchFromGitHub, rofi, gnused }:

stdenv.mkDerivation rec {
  rev = "168efd2608fdb88b1aff3e0244bda8402169f207";
  name = "rofi-menugen-2015-12-28-${builtins.substring 0 7 rev}";
  src = fetchFromGitHub {
    owner = "octotep";
    repo = "menugen";
    inherit rev;
    sha256 = "09fk9i6crw772qlc5zld35pcff1jq4jcag0syial2q000fbpjx5m";
  };
  patchPhase = ''
    sed -i -e "s|menugenbase|$out/bin/rofi-menugenbase|" menugen
    sed -i -e "s|rofi |${rofi}/bin/rofi |" menugen
    sed -i -e "s|sed |${gnused}/bin/sed |" menugenbase
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp menugen $out/bin/rofi-menugen
    cp menugenbase $out/bin/rofi-menugenbase
  '';
  meta = with stdenv.lib; {
    description = "Generates menu based applications using rofi";
    homepage = https://github.com/octotep/menugen;
    maintainers = with maintainers; [ garbas ];
    platforms = platforms.all;
  };
}
