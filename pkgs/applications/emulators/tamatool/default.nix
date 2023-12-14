{ lib
, stdenv
, fetchFromGitHub
, zip
, copyDesktopItems
, libpng
, SDL2
, SDL2_image
, darwin

# Optionally bundle a ROM file
, rom ? null
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tamatool";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "jcrona";
    repo = "tamatool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VDmpIBuMWg3TwfCf9J6/bi/DaWip6ESAQWvGh2SH+A8=";
    fetchSubmodules = true;
  };

  # * Point to the installed rom and res directory
  # * Tell the user to use --rom instead of telling them to place the rom in the
  #   program directory (it's immutable!)
  postPatch = ''
    substituteInPlace src/tamatool.c \
      --replace '#define RES_PATH'          "#define RES_PATH         \"$out/share/tamatool/res\"          //" \
      --replace '#define ROM_PATH'          "#define ROM_PATH         \"$out/share/tamatool/rom.bin\"      //" \
      --replace '#define ROM_NOT_FOUND_MSG' '#define ROM_NOT_FOUND_MSG "You need to use the --rom option!" //'
  '';

  nativeBuildInputs = [
    zip
    copyDesktopItems
  ];

  buildInputs = [
    libpng
    SDL2
    SDL2_image
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  makeFlags = [
    "-Clinux"
    "VERSION=${finalAttrs.version}"
    "CFLAGS+=-I${SDL2.dev}/include/SDL2"
    "CFLAGS+=-I${SDL2_image}/include/SDL2"
    "DIST_PATH=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  desktopItems = [ "linux/tamatool.desktop" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 linux/tamatool $out/bin/tamatool
    mkdir -p $out/share/tamatool
    cp -r res $out/share/tamatool/res
    install -Dm644 linux/tamatool.png $out/share/icons/hicolor/128x126/apps/tamatool.png
    ${lib.optionalString (rom != null) "install -Dm677 ${rom} $out/share/tamatool/rom.bin"}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A cross-platform Tamagotchi P1 explorer";
    homepage = "https://github.com/jcrona/tamatool";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})
