{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  which,
  procps,
  kbd,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "logkeys";
  version = "2018-01-22";

  src = fetchFromGitHub {
    owner = "kernc";
    repo = "logkeys";
    rev = "7a9f19fb6b152d9f00a0b3fe29ab266ff1f88129";
    hash = "sha256-FvU392jrHaulUyoLQ6B4+PmbK4YZGkhHgbzGERKQ08w=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [
    which
    procps
    kbd
  ];

  postPatch = ''
    substituteInPlace src/Makefile.am --replace 'root' '$(id -u)'
    substituteInPlace configure.ac --replace '/dev/input' '/tmp'
    sed -i '/chmod u+s/d' src/Makefile.am
  '';

  preConfigure = "./autogen.sh";

  passthru.tests.nixos = nixosTests.logkeys;

  meta = {
    description = "GNU/Linux keylogger that works";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/kernc/logkeys";
    maintainers = with lib.maintainers; [
      mikoim
    ];
    platforms = lib.platforms.linux;
  };
}
