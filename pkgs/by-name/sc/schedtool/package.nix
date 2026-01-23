{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schedtool";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "freequaos";
    repo = "schedtool";
    rev = "schedtool-${finalAttrs.version}";
    hash = "sha256-1987n2JilQlNJAc7KhxUe4W7kK0Dqgal6wGo5KwzvPE=";
  };

  # Fix build with GCC 13
  postPatch = ''
    substituteInPlace schedtool.c \
      --replace-fail 'TAB[policy] : policy' 'TAB[policy] : (char*)(intptr_t)policy'
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "DESTPREFIX="
  ];

  meta = {
    description = "Query or alter a process' scheduling policy under Linux";
    mainProgram = "schedtool";
    homepage = "https://github.com/freequaos/schedtool";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
