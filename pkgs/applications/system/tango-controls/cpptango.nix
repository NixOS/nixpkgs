{ cmake
, cppzmq
, doxygen
, fetchurl
, fetchFromGitLab
, tango-idl
, graphviz
, lib
, libjpeg_turbo
, libsodium
, pkg-config
, stdenv
, zeromq
, omniorb
, zlib
}:
let
  # tango doesn't support the latest version of omniorb
  omniorb_4_2 = omniorb.overrideAttrs (self: super: rec {
    version = "4.2.5";

    src = fetchurl {
      url = "mirror://sourceforge/project/omniorb/omniORB/omniORB-${version}/omniORB-${version}.tar.bz2";
      sha256 = "1fvkw3pn9i2312n4k3d4s7892m91jynl8g1v2z0j8k1gzfczjp7h";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "cpptango";
  version = "9.4.2";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = pname;
    rev = version;
    hash = "sha256-ji5Ti5Lc4wKYydgAzj+rZiCcVZHCzy/NUqh+koO5rhg=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    zlib
    omniorb_4_2
    zeromq
    cppzmq
    tango-idl
    libjpeg_turbo
    libsodium
    doxygen
    # needed for the docs
    graphviz
  ];
  propagatedBuildInputs = [
    omniorb_4_2
    cppzmq
    zeromq
    libjpeg_turbo
    libsodium
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  postPatch = ''
    sed -i -e 's#Requires: libzmq#Requires: libzmq cppzmq#' -e 's#libdir=.*#libdir=@CMAKE_INSTALL_FULL_LIBDIR@#' tango.pc.cmake
  '';

  meta = with lib; {
    description = "Open Source solution for SCADA and DCS";
    longDescription = ''
      Tango Controls is a toolkit for connecting hardware and software together. It is a mature software which is used by tens of sites to run highly complicated accelerator complexes and experiments 24 hours a day. It is free and Open Source. It is ideal for small and large installations. It provides full support for 3 programming languages - C++, Python and Java.
    '';
    homepage = "https://www.tango-controls.org";
    changelog = "https://gitlab.com/tango-controls/cppTango/-/blob/${version}/RELEASE_NOTES.md";
    downloadPage = "https://gitlab.com/tango-controls/TangoSourceDistribution/-/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.unix;
  };

}
