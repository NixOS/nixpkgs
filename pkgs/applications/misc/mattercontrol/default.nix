{ stdenv, fetchurl, mono, dpkg, makeWrapper, sqlite }:

stdenv.mkDerivation rec {
  name = "MatterControl-${version}";
  version = "1.7.5";
  src = fetchurl {
    url = "https://mattercontrol.appspot.com/downloads/mattercontrol-linux/release";
    sha256 = "0jq81a1vh7zc0m5gc7mp2dcha439d56b6mma5kczjzk5k8ilqn8y";
  };
  nativeBuildInputs = [ dpkg makeWrapper ];
  unpackPhase = ''
    dpkg-deb -x $src ./
  '';
  installPhase = ''
    mv usr $out
    makeWrapper ${mono}/bin/mono $out/bin/mattercontrol \
      --add-flags $out/lib/mattercontrol/MatterControl.exe \
      --prefix LD_LIBRARY_PATH : ${sqlite.out}/lib
  '';
  meta = {
    description = "All-in-one software package that lets you design, slice, organize, and manage your 3D prints";
    homepage = https://www.matterhackers.com/;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.puffnfresh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
