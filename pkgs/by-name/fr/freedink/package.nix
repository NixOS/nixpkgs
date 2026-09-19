{
  autoreconfHook,
  cxxtest,
  desktopToDarwinBundle,
  fetchgit,
  fontconfig,
  gettext,
  glm,
  gnulib,
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

    src = fetchgit {
      url = "https://git.savannah.gnu.org/git/freedink/freedink-data.git";
      tag = "v${final.version}";
      hash = "sha256-8/yKy/oAPQkvNNQPWYCaHREHly7vJE63956ky0KVYI0=";
    };

    postPatch = "substituteInPlace Makefile --replace-fail /usr/local $out";
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freedink";
  version = "109.6";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/freedink.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D+/Reg0+K9J1WcOpe3xdnIv90Cl0GCmB/2M1XU/3eOg=";
  };

  patches = [ ./freedink.patch ];

  nativeBuildInputs = [
    autoreconfHook
    cxxtest
    gettext
    gnulib
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

  env.GNULIB_TOOL_IMPL = "sh";

  postPatch = ''
    gnulib-tool --update --more-symlinks
  '';

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
  };
})
