{ stdenv, fetchurl, kdelibs, kdebase_workspace, gettext }:

stdenv.mkDerivation rec {
  name = "rsibreak-0.11";

  src = fetchurl {
    url = "${meta.homepage}/files/${name}.tar.bz2";
    sha256 = "1yrf73r8mixskh8b531wb8dfs9z7rrw010xsrflhjhjmqh94h8mw";
  };

  buildNativeInputs = [ gettext ];

  buildInputs = [ kdelibs kdebase_workspace ];

  meta = {
    homepage = http://www.rsibreak.org/;
    description = "Repetitive Strain Injury prevention";
    inherit (kdelibs.meta) platforms maintainers;
  };
}
