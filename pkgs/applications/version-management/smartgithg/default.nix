{ stdenv, fetchurl, lib, makeWrapper
, jre
, gtk, glib
, libXtst
, git, mercurial, subversion
, which
}:

let
  the_version = "6_5_3";

in

stdenv.mkDerivation rec {
  name = "smartgithg-${the_version}";

  src = fetchurl {
    url = "http://www.syntevo.com/download/smartgit/" +
          "smartgit-generic-${the_version}.tar.gz";
    sha256 = "0hz1y29ipls58fizr27w6rbv7v7qbbc1h70xvjjd8c94k9ajmav9";
  };

  buildInputs = [
    makeWrapper
    jre
  ];

  buildCommand = let
    pkg_path = "$out/${name}";
    bin_path = "$out/bin";
    runtime_paths = lib.makeSearchPath "bin" [
      jre
      git mercurial subversion
      which
    ];
    runtime_lib_paths = lib.makeLibraryPath [
      gtk glib
      libXtst
    ];
  in ''
    tar xvzf $src
    mkdir -pv $out
    mkdir -pv ${pkg_path}
    # unpacking should have produced a dir named 'smartgit'
    cp -a smartgit/* ${pkg_path}
    mkdir -pv ${bin_path}
    [ -d ${jre}/lib/openjdk ] \
      && jre=${jre}/lib/openjdk \
      || jre=${jre}
    makeWrapper ${pkg_path}/bin/smartgit.sh ${bin_path}/smartgit \
      --prefix PATH : ${runtime_paths} \
      --prefix LD_LIBRARY_PATH : ${runtime_lib_paths} \
      --prefix JRE_HOME : ${jre} \
      --prefix JAVA_HOME : ${jre} \
      --prefix SMARTGITHG_JAVA_HOME : ${jre}
    patchShebangs $out
    cp ${bin_path}/smartgit ${bin_path}/smartgithg
  '';

  meta = with stdenv.lib; {
    description = "GUI for Git, Mercurial, Subversion";
    homepage = http://www.syntevo.com/smartgit/;
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
