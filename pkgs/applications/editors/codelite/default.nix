{ stdenv, fetchFromGitHub, pkgconfig, wxGTK, gtk2, cmake, sqlite, which, libssh
, flex, lldb, hunspell, llvmPackages, glib, pcre, bash
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "10.0";
  pname = "codelite";

  src = fetchFromGitHub {
    owner = "eranif";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "1n6n4wqdfl2g92b5swz3l394x0xjgim89x3jvwv1gsci7qm90akz";
  };

  buildInputs = [
    pkgconfig wxGTK gtk2 cmake sqlite which libssh pcre
    flex lldb hunspell llvmPackages.clang-unwrapped
  ];

  prePatch = ''
    substituteInPlace ./Runtime/codelite_xterm --replace "/bin/bash" "${bash}/bin/bash"
  '';

  patches = [
    ./glib.patch
  ];

  cmakeFlags = [
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.dev}/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${gtk2.dev}/include"
    "-DWITH_FLEX=TRUE"
    "-DCMAKE_LIBRARY_PATH=${llvmPackages.clang-unwrapped}/lib"
    "-DCMAKE_INCLUDE_PATH=${llvmPackages.clang-unwrapped}/include;${glib.dev}/include/glib-2.0/glib;${gtk2.out}/lib/gtk-2.0/include/"
    "-DGLIB2_FIND_QUIETLY=FALSE"
  ];

  preConfigure = ''
    substituteInPlace ./cmake/Modules/FindLibClang.cmake --replace "/bin/grep" "grep"
    substituteInPlace ./cmake/Modules/FindGLIB2.cmake --replace "IF (NOT GLIB2_FIND_QUIETLY)" "IF (TRUE)"
    cmakeFlags="$cmakeFlags -DCL_PREFIX=$out"
  '';

  meta = with stdenv.lib; {
    maintainers = [ ];
    platforms = platforms.all;
    description = "An open source, free, cross platform IDE for the C/C++ programming languages which runs on all major Platforms ( OSX, Windows and Linux )";
    homepage = https://codelite.org;
    license = licenses.gpl2;
  };
}
