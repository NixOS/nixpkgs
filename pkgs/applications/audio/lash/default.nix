{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  gtk2,
  libjack2,
  libuuid,
  libxml2,
  makeWrapper,
  pkg-config,
  readline,
}:

assert libuuid != null;

stdenv.mkDerivation rec {
  pname = "lash";
  version = "0.5.4";

  src = fetchurl {
    url = "mirror://savannah/lash/${pname}-${version}.tar.gz";
    sha256 = "05kc4brcx8mncai0rj2gz4s4bsrsy9q8xlnaddf75i0m8jl7snhh";
  };

  # http://permalink.gmane.org/gmane.linux.redhat.fedora.extras.cvs/822346
  patches = [
    ./socket.patch
    ./gcc-47.patch
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    alsa-lib
    gtk2
    libjack2
    libxml2
    readline
  ];
  propagatedBuildInputs = [ libuuid ];
  NIX_LDFLAGS = "-lm -lpthread -luuid";

  postInstall = ''
    for i in lash_control lash_panel
      do wrapProgram "$out/bin/$i" --prefix LD_LIBRARY_PATH ":" "${libuuid}/lib"
    done
  '';

  meta = with lib; {
    description = "A Linux Audio Session Handler";
    longDescription = ''
      Session management system for GNU/Linux audio applications.
    '';
    homepage = "https://www.nongnu.org/lash";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
