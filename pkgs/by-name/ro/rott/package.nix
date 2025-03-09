{
  stdenv,
  lib,
  fetchurl,
  fetchzip,
  SDL_compat,
  SDL_mixer,
  makeDesktopItem,
  copyDesktopItems,
  unzip,
  buildShareware ? false,
  withSharewareData ? buildShareware,
}:
assert withSharewareData -> buildShareware;

let
  datadir = "share/data/rott-shareware/";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rott";
  version = "1.1.2";

  __structuredAttrs = true;
  srcs =
    [
      (fetchurl {
        url = "https://icculus.org/rott/releases/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
        hash = "sha256-ECUW6MMS9rC79sYj4fAcv7vDFKzorf4fIB1HsVvZJ/8=";
      })
    ]
    ++ lib.optional withSharewareData (fetchzip {
      url = "http://icculus.org/rott/share/1rott13.zip";
      hash = "sha256-l0pP+mNPAabGh7LZrwcB6KOhPRSycrZpAlPVTyDXc6Y=";
      stripRoot = false;
    });

  sourceRoot = "rott-${finalAttrs.version}/rott";

  patches = [ ./cflags.patch ];

  nativeBuildInputs = [ copyDesktopItems ] ++ lib.optional withSharewareData unzip;

  buildInputs = [
    SDL_compat
    SDL_mixer
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "SHAREWARE=${if buildShareware then "1" else "0"}"
    # when using SDL_compat instead of SDL1, SDL_mixer isn't correctly detected,
    # but there is no harm just specifying it
    ''EXTRACFLAGS=-I${lib.getDev SDL_mixer}/include/SDL -DDATADIR=\"${
      if withSharewareData then "$(out)/${datadir}" else ""
    }\"''
  ];

  installPhase = ''
    runHook preInstall

    ${lib.optionalString withSharewareData ''
      mkdir -p "$out/${datadir}"
      unzip -d "$out/${datadir}" ../../source/ROTTSW13.SHR
    ''}
    install -Dm755 -t $out/bin rott

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rott";
      exec = "rott";
      desktopName = "Rise of the Triad: ${if buildShareware then "The HUNT Begins" else "Dark War"}";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "SDL port of Rise of the Triad";
    mainProgram = "rott";
    homepage = "https://icculus.org/rott/";
    license = with lib.licenses; [ gpl2Plus ] ++ lib.optional withSharewareData unfreeRedistributable;
    maintainers = with lib.maintainers; [ sander ];
    platforms = lib.platforms.all;
  };
})
