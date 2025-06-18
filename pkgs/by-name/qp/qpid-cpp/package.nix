{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  boost183,
  cmake,
  libuuid,
  python3,
  ruby,
}:

stdenv.mkDerivation rec {
  pname = "qpid-cpp";
  version = "1.39.0";

  src = fetchurl {
    url = "mirror://apache/qpid/cpp/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-eYDQ6iHVV1WUFFdyHGnbqGIjE9CrhHzh0jP7amjoDSE=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    boost183
    libuuid
    ruby
  ];

  patches = [
    (fetchpatch {
      name = "python3-managementgen";
      url = "https://github.com/apache/qpid-cpp/commit/0e558866e90ef3d5becbd2f6d5630a6a6dc43a5d.patch";
      hash = "sha256-pV6xx8Nrys/ZxIO0Z/fARH0ELqcSdTXLPsVXYUd3f70=";
    })
  ];

  # the subdir managementgen wants to install python stuff in ${python} and
  # the installation tries to create some folders in /var
  postPatch = ''
    sed -i '/managementgen/d' CMakeLists.txt
    sed -i '/ENV/d' src/CMakeLists.txt
    sed -i '/management/d' CMakeLists.txt
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-Wno-error=maybe-uninitialized"
    ]
    ++ lib.optionals stdenv.cc.isGNU [
      "-Wno-error=deprecated-copy"
    ]
  );

  meta = with lib; {
    homepage = "https://qpid.apache.org";
    description = "AMQP message broker and a C++ messaging API";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
