{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  bzip2,
  doxygen,
  glib,
  curl,
  libxml2,
  python3,
  rpm,
  openssl,
  sqlite,
  file,
  xz,
  bash-completion,
  zstd,
  zchunk,
  libmodulemd,
}:

stdenv.mkDerivation rec {
  pname = "createrepo_c";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "createrepo_c";
    tag = version;
    hash = "sha256-2mvU2F9rvG4FtDgq+M9VXWg+c+AsW/+tDPaEj7zVmQ0=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'execute_process(COMMAND ''${PKG_CONFIG_EXECUTABLE} --variable=completionsdir bash-completion OUTPUT_VARIABLE BASHCOMP_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)' "SET(BASHCOMP_DIR \"$out/share/bash-completion/completions\")"
    substituteInPlace src/python/CMakeLists.txt \
      --replace-fail "EXECUTE_PROCESS(COMMAND \''${PYTHON_EXECUTABLE} -c \"from sys import stdout; from sysconfig import get_path; stdout.write(get_path('platlib'))\" OUTPUT_VARIABLE PYTHON_INSTALL_DIR)" "SET(PYTHON_INSTALL_DIR \"$out/${python3.sitePackages}\")"

    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED (VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    rpm
    bash-completion
  ];

  buildInputs = [
    bzip2
    glib
    curl
    libxml2
    python3
    openssl
    sqlite
    file
    xz
    zstd
    zchunk
    libmodulemd
  ];

  meta = with lib; {
    description = "C implementation of createrepo";
    homepage = "https://rpm-software-management.github.io/createrepo_c/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
