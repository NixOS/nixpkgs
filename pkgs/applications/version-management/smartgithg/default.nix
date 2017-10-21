{ stdenv, fetchurl, lib, makeWrapper
, jre
, gtk2, glib
, libXtst
, git, mercurial, subversion
, which
}:

stdenv.mkDerivation rec {
  name = "smartgithg-${version}";
  version = "17_0_3";

  src = fetchurl {
    url = "http://www.syntevo.com/static/smart/download/smartgit/smartgit-linux-${version}.tar.gz";
    sha256 = "1swgh1bgjrbpxhj27b4gmn806nkqcl1w8lz7j7xkx3dlgljipw33";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jre ];

  buildCommand = let
    pkg_path = "$out/${name}";
    bin_path = "$out/bin";
    install_freedesktop_items = ./install_freedesktop_items.sh;
    runtime_paths = lib.makeBinPath [
      jre
      #git mercurial subversion # the paths are requested in configuration
      which
    ];
    runtime_lib_paths = lib.makeLibraryPath [
      gtk2 glib
      libXtst
    ];
  in ''
    tar xvzf $src
    mkdir -pv $out
    mkdir -pv ${pkg_path}
    # unpacking should have produced a dir named 'smartgit'
    cp -a smartgit/* ${pkg_path}
    mkdir -pv ${bin_path}
    jre=${jre.home}
    makeWrapper ${pkg_path}/bin/smartgit.sh ${bin_path}/smartgit \
      --prefix PATH : ${runtime_paths} \
      --prefix LD_LIBRARY_PATH : ${runtime_lib_paths} \
      --prefix JRE_HOME : ${jre} \
      --prefix JAVA_HOME : ${jre} \
      --prefix SMARTGITHG_JAVA_HOME : ${jre}
    patchShebangs $out
    cp ${bin_path}/smartgit ${bin_path}/smartgithg

    ${install_freedesktop_items} "${pkg_path}/bin" "$out"
  '';

  meta = with stdenv.lib; {
    description = "GUI for Git, Mercurial, Subversion";
    homepage = http://www.syntevo.com/smartgit/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jraygauthier ];
  };
}
