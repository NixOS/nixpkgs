{ stdenv, fetchurl, lib, makeWrapper
, jre
, gtk, glib
, libXtst
, git, mercurial, subversion
, which
}:

stdenv.mkDerivation rec {
  name = "smartgithg-${version}";
  version = "7_0_0";

  src = fetchurl {
    url = "http://www.syntevo.com/downloads/smartgit/smartgit-generic-${version}.tar.gz";
    sha256 = "099hnpczh2c0s86nsdybymmm4903n0bsjdq1fpdmm0x5w4216iy6";
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
    jre=${jre.home}
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
