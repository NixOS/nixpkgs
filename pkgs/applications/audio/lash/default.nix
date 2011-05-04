{ stdenv, fetchurl, alsaLib, gtk, jackaudio, libuuid, libxml2
, makeWrapper, pkgconfig, readline }:

assert libuuid != null;

stdenv.mkDerivation  rec {
  name = "lash-${version}";
  version = "0.5.4";

  src = fetchurl {
    url = "mirror://savannah/lash/${name}.tar.gz";
    sha256 = "05kc4brcx8mncai0rj2gz4s4bsrsy9q8xlnaddf75i0m8jl7snhh";
  };

  patches = [ ./socket.patch ];

  buildInputs = [ alsaLib gtk jackaudio libuuid libxml2 makeWrapper
    pkgconfig readline ];

  postInstall = ''
    for i in lash_control lash_panel
      do wrapProgram "$out/bin/$i" --prefix LD_LIBRARY_PATH ":" "${libuuid}/lib"
    done
  '';

  meta = with stdenv.lib; {
    description = "LASH Audio Session Handler";
    longDescription = ''
      Session management system for GNU/Linux audio applications.
    '';
    homepage = http://www.nongnu.org/lash;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
