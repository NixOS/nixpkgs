{
  autoreconfHook,
  cxxtest,
  desktopToDarwinBundle,
  fetchurl,
  fontconfig,
  gettext,
  glm,
  help2man,
  intltool,
  lib,
  nix-update-script,
  pkg-config,
  SDL2,
  SDL2_gfx,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  stdenv,
}:

let
  data = stdenv.mkDerivation (final: {
    pname = "freedink-data";
    version = "1.08.20190120";

    src = fetchurl {
      url = "mirror://gnu/freedink/freedink-data-${final.version}.tar.gz";
      hash = "sha256-cV9EdzsFtzqeybYrDhUvPygb4aFRL7qqOGF22pTP+50=";
    };

    prePatch = "substituteInPlace Makefile --replace-fail /usr/local $out";
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freedink";
  version = "109.6";

  src = fetchurl {
    url = "mirror://gnu/freedink/freedink-${finalAttrs.version}.tar.gz";
    hash = "sha256-Xgs1rI9G17uH5lbv1fnHwqwabFGakI/FtYHlJleYEAI=";
  };

  patches = [ ./freedink.patch ];

  nativeBuildInputs = [
    autoreconfHook
    cxxtest
    gettext
    help2man
    intltool
    pkg-config
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    fontconfig
    glm
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  postInstall = ''
    mkdir -p "$out/share/"
    ln -s ${data}/share/dink "$out/share/"
  '';

  enableParallelBuilding = true;

  passthru = {
    # Data rarely changes, so not covered by update-script
    updateScript = nix-update-script { };
    inherit data;
  };

  meta = {
    description = "Free, portable and enhanced version of the Dink Smallwood game engine";
    longDescription = ''
      GNU FreeDink is a new and portable version of the Dink Smallwood
      game engine, which runs the original game as well as its D-Mods,
      with close compatibility, under multiple platforms.
    '';
    homepage = "https://gnu.org/software/freedink/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      iedame
      philocalyst
    ];
    platforms = lib.platforms.all;
    mainProgram = "freedink";
    teams = [ lib.teams.gaming ];
  };
})
