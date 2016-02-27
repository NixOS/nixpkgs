{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "i3blocks-${version}";
  version = "1.4";

  src = fetchurl {
    url = "https://github.com/vivien/i3blocks/releases/download/${version}/${name}.tar.gz";
    sha256 = "c64720057e22cc7cac5e8fcd58fd37e75be3a7d5a3cb8995841a7f18d30c0536";
  };

  makeFlags = "all";
  installFlags = "PREFIX=\${out} VERSION=${version}";

  meta = with stdenv.lib; {
    description = "A flexible scheduler for your i3bar blocks";
    homepage = https://github.com/vivien/i3blocks;
    license = licenses.gpl3;
    maintainers = [ "MindTooth" ];
    platforms = platforms.all;
  };
}
