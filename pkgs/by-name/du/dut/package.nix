{
  stdenv,
  lib,
  fetchFromGitea,
}:

stdenv.mkDerivation {
  pname = "dut";
  version = "0-unstable-2024-07-31";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "201984";
    repo = "dut";
    rev = "041c6f26162c2286776fac246ddbda312da1563d";
    hash = "sha256-YrBV5rG9rASI/5pwG3kcHoOvXBHhLJHvFFrvNhmGq2Y=";
  };

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = with lib; {
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    description = "A disk usage calculator for Linux";
    homepage = "https://codeberg.org/201984/dut";
    license = licenses.gpl3;
    maintainers = with maintainers; [ errnoh ];
    mainProgram = "dut";
  };
}
