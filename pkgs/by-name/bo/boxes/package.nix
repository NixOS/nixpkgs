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

stdenv.mkDerivation (finalAttrs: {
  pname = "boxes";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "ascii-boxes";
    repo = "boxes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dkL5VYs6j9LzvhCLU4BEbiTDWJpW1vQrmLWQ40P3Yzo=";
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

  meta = {
    description = "Command line program which draws, removes, and repairs ASCII art boxes";
    mainProgram = "boxes";
    homepage = "https://boxes.thomasjensen.com";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ waiting-for-dev ];
    platforms = lib.platforms.unix;
  };
})
