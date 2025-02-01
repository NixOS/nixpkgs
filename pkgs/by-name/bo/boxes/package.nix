{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  pcre2,
  libunistring,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "boxes";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "ascii-boxes";
    repo = "boxes";
    rev = "v${version}";
    hash = "sha256-dvhb5KWBQt7g4n0ZTQMcJQljIfavV3g8i+P3PWB6Gwk=";
  };

  # Building instructions:
  # https://boxes.thomasjensen.com/build.html#building-on-linux--unix
  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [
    pcre2
    libunistring
    ncurses
  ];

  dontConfigure = true;

  # Makefile references a system wide config file in '/usr/share'. Instead, we
  # move it within the store by default.
  preBuild = ''
    substituteInPlace Makefile \
      --replace-fail "GLOBALCONF = /usr/share/boxes" \
                "GLOBALCONF=${placeholder "out"}/share/boxes/boxes-config"
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    install -Dm755 -t $out/bin out/boxes
    install -Dm644 -t $out/share/boxes boxes-config
    install -Dm644 -t $out/share/man/man1 doc/boxes.1
  '';

  meta = with lib; {
    description = "Command line program which draws, removes, and repairs ASCII art boxes";
    mainProgram = "boxes";
    homepage = "https://boxes.thomasjensen.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ waiting-for-dev ];
    platforms = platforms.unix;
  };
}
