{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
  pkg-config,
  check,
}:
stdenv.mkDerivation rec {
  pname = "libcork";
  version = "1.0.0--rc3";

  src = fetchFromGitHub {
    owner = "dcreager";
    repo = "libcork";
    rev = version;
    sha256 = "152gqnmr6wfmflf5l6447am4clmg3p69pvy3iw7yhaawjqa797sk";
  };

  postPatch = ''
    # N.B. We need to create this file, otherwise it tries to use git to
    # determine the package version, which we do not want.
    echo "${version}" > .version-stamp
    echo "${version}" > .commit-stamp

    # N.B. We disable tests by force, since their build is broken.
    sed -i '/add_subdirectory(tests)/d' ./CMakeLists.txt

    # https://github.com/dcreager/libcork/issues/173
    substituteInPlace cmake/FindCTargets.cmake \
      --replace '\$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR} \
      --replace '\$'{datarootdir}/'$'{base_docdir} '$'{CMAKE_INSTALL_FULL_DOCDIR}
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ check ];

  doCheck = false;

  postInstall = ''
    ln -s $out/lib/libcork.so $out/lib/libcork.so.1
  '';

  meta = with lib; {
    homepage = "https://github.com/dcreager/libcork";
    description = "Simple, easily embeddable cross-platform C library";
    mainProgram = "cork-hash";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
