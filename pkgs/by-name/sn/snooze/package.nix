{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "snooze";
  version = "0.6";
  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "snooze";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nPJ1W/37duJoyKopkQl/UHDv+MaRFHGuiQI16VIU6HA=";
  };
  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  meta = {
    description = "Tool for waiting until a particular time and then running a command";
    homepage = "https://github.com/leahneukirchen/snooze";
    maintainers = with lib.maintainers; [ kaction ];
    license = lib.licenses.cc0;
    platforms = lib.platforms.unix;
    mainProgram = "snooze";
  };
})
