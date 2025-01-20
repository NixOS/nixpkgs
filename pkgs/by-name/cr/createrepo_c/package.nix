{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  bzip2,
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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "createrepo_c";
    tag = version;
    hash = "sha256-IWn1in1AMN4brekerj+zu1OjTl+PE7fthU5+gcBzVU0=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'execute_process(COMMAND ''${PKG_CONFIG_EXECUTABLE} --variable=completionsdir bash-completion OUTPUT_VARIABLE BASHCOMP_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)' "SET(BASHCOMP_DIR \"$out/share/bash-completion/completions\")"
    substituteInPlace src/python/CMakeLists.txt \
      --replace-fail "EXECUTE_PROCESS(COMMAND \''${PYTHON_EXECUTABLE} -c \"from sys import stdout; from sysconfig import get_path; stdout.write(get_path('platlib'))\" OUTPUT_VARIABLE PYTHON_INSTALL_DIR)" "SET(PYTHON_INSTALL_DIR \"$out/${python3.sitePackages}\")"
  '';

  nativeBuildInputs = [
    cmake
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
    maintainers = with maintainers; [ copumpkin ];
  };
}
