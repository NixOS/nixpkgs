{
  lib,
  stdenv,
  fetchurl,
  groff,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "setserial";
  version = "2.17";

  src = fetchurl {
    url = "mirror://sourceforge/setserial/setserial-${finalAttrs.version}.tar.gz";
    sha256 = "0jkrnn3i8gbsl48k3civjmvxyv9rbm1qjha2cf2macdc439qfi3y";
  };

  patches = [ ./gcc-fixes.patch ];

  nativeBuildInputs = [
    autoreconfHook
    groff
  ];

  postConfigure = ''
    substituteInPlace Makefile \
      --replace-fail /usr/man/ /share/man/ \
      --replace-fail DESTDIR out
  '';

  preInstall = ''
    mkdir -p "$out/bin" "$out/share/man/man8"
  '';

  meta = {
    description = "Serial port configuration utility";
    homepage = "https://setserial.sourceforge.net";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    mainProgram = "setserial";
    maintainers = [ lib.maintainers.mmlb ];
  };
})
