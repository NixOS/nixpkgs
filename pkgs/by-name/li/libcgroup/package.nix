{
  lib,
  stdenv,
  fetchFromGitHub,
  pam,
  bison,
  flex,
  systemdLibs,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libcgroup";
  version = "3.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-CnejQcOyW3QzHuvsAdKe4M4XgmG9ufRaEBdO48+8ZqQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];
  buildInputs = [
    pam
    systemdLibs
  ];

  postPatch = ''
    substituteInPlace src/tools/Makefile.am \
      --replace 'chmod u+s' 'chmod +x'
  '';

  meta = {
    description = "Library and tools to manage Linux cgroups";
    homepage = "https://github.com/libcgroup/libcgroup";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
