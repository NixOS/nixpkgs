{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  boost,
  libevent,
  autoreconfHook,
  db4,
  pkg-config,
  protobuf,
  hexdump,
  zeromq,
  withGui ? true,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "digibyte";
  version = "7.17.3";

  # Satisfy nixpkgs-vet requirements for new packages
  strictDeps = true;
  __structuredAttrs = true;

  name = finalAttrs.pname + toString (lib.optional (!withGui) "d") + "-" + finalAttrs.version;

  src = fetchFromGitHub {
    owner = "digibyte-core";
    repo = "digibyte";
    rev = "v${finalAttrs.version}";
    sha256 = "zPwnC2qd28fA1saG4nysPlKU1nnXhfuSG3DpCY6T+kM=";
  };

  postPatch = ''
    sed -i '1i #include <deque>' src/httpserver.cpp
    sed -i '1i #include <stdexcept>' src/support/lockedpool.cpp
    sed -i '1i #include <QPainterPath>' src/qt/trafficgraphwidget.cpp

    sed -i -e 's/\b_1\b/boost::placeholders::_1/g' \
           -e 's/\b_2\b/boost::placeholders::_2/g' \
           -e 's/\b_3\b/boost::placeholders::_3/g' \
           -e 's/\b_4\b/boost::placeholders::_4/g' \
           -e 's/\b_5\b/boost::placeholders::_5/g' \
           src/qt/*.cpp src/qt/*.h

    # Fix Boost 1.74+ filesystem API change (copy_option -> copy_options)
    find src -type f -exec sed -i 's/fs::copy_option::overwrite_if_exists/fs::copy_options::overwrite_existing/g' {} +

    # Fix Boost 1.85+ recursive_directory_iterator API changes
    find src -type f -exec sed -i 's/\.no_push()/.disable_recursion_pending()/g' {} +
    find src -type f -exec sed -i 's/\.level()/.depth()/g' {} +

    # Fix Boost 1.85+ basename and extension API removals
    # We must explicitly cast to fs::path before calling the modern methods
    find src -type f -exec sed -i 's/fs::basename(\([^)]*\))/fs::path(\1).stem().string()/g' {} +
    find src -type f -exec sed -i 's/fs::extension(\([^)]*\))/fs::path(\1).extension().string()/g' {} +

    # Lobotomize the Boost macros.
    for m4file in $(find . -name "ax_boost_*.m4"); do
      sed -i 's/AC_MSG_ERROR/AC_MSG_WARN/g' "$m4file"
    done
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ]
  ++ lib.optionals withGui [
    qt5.wrapQtAppsHook
    protobuf
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
  ]
  ++ lib.optionals withGui [
    qt5.qtbase
    qt5.qttools
    protobuf
  ];

  enableParallelBuilding = true;

  env.CXXFLAGS = "-Wno-error -std=c++17";

  configureFlags = [
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    "BOOST_SYSTEM_LIB="
    "BOOST_FILESYSTEM_LIB=-lboost_filesystem"
    "BOOST_PROGRAM_OPTIONS_LIB=-lboost_program_options"
    "BOOST_THREAD_LIB=-lboost_thread"
    "BOOST_CHRONO_LIB=-lboost_chrono"
    "--disable-werror"
    "--disable-tests"
    "--disable-gui-tests"
    "--disable-bench"
  ]
  ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${qt5.qtbase.dev}/bin:${qt5.qttools.dev}/bin"
  ];

  meta = {
    description = "DigiByte (DGB) is a rapidly growing decentralized, global blockchain";
    homepage = "https://digibyte.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.linux;
  };
})
