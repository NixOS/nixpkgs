{ stdenv, fetchFromGitLab
, libiconv, zlib
, pkgconfig

, sdl2Support ? true
, SDL2 ? null, SDL2_image ? null
, sdlSupport ? false
, SDL ? null, SDL_image ? null
, windowsSupport ? stdenv.targetPlatform.isWindows
, x11Support ? stdenv.targetPlatform.isUnix
, libX11 ? null

, joystickSupport ? false
, layersSupport ? true
, luaSupport ? true, lua ? null
, pngSupport ? true, libpng ? null
, recoilSupport ? true, recoil ? null
, tiffSupport ? true, libtiff ? null
, ttfSupport ? true, freetype ? null, fontconfig ? null
, SDL_ttf ? null, SDL2_ttf ? null
}:

assert sdl2Support -> !sdlSupport;
assert sdl2Support -> SDL != null && SDL_image != null;

assert sdlSupport -> !sdl2Support;
assert sdlSupport -> SDL2 != null && SDL2_image != null;

assert x11Support -> libX11 != null;

assert luaSupport -> lua != null;
assert pngSupport -> libpng != null;
assert recoilSupport -> recoil != null;
assert tiffSupport -> libtiff != null;

assert ttfSupport -> freetype != null && fontconfig != null &&
  (sdlSupport && SDL_ttf != null || sdl2Support && SDL2_ttf != null);

let
  inherit (stdenv) lib targetPlatform;
  inherit (lib) optional optionals;

  multimediaApi = if windowsSupport then "win32"
    else if sdl2Support then "sdl2"
    else if sdlSupport then "sdl"
    else if x11Support then "x11"
    else throw "No multimedia API yet available.";

  sdl = if sdl2Support then {
    SDL = SDL2;
    SDL_image = SDL2_image;
    SDL_ttf = SDL2_ttf;
  } else if sdlSupport then {
    inherit SDL SDL_image SDL_ttf;
  } else null;
  isSDL = sdl != null;
in

stdenv.mkDerivation rec {
  name = "grafx2-${version}";
  version = "2.6";

  src = fetchFromGitLab {
    owner = "Grafx2";
    repo = "grafx2";
    rev = "5d8c61e41011a8106359343243e1050af4e7fd1f";
    sha256 = "1z8qjq07y4sf2kpc1b98dwxzbmpp3ayyyhc5bbnnx60j3xzbw851";
    postFetch = ''
      (cd $out
      # remember to update along with rev from a git checkout
      # GIT_REVISION=$(git rev-list --count 1af8c74f53110e349d8f0d19b14599281913f71f..)
      # GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
      GIT_REVISION=2475
      GIT_BRANCH=master
      if [[ GIT_BRANCH != master ]]; then
        GIT_REVISION=$GIT_REVISION-$GIT_BRANCH
      fi
      echo "const char SVN_revision[]=\"$GIT_REVISION\";" > src/version.c)
    '';
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libiconv zlib ] ++
    (optionals isSDL [ sdl.SDL sdl.SDL_image ]) ++
    (optional x11Support libX11) ++
    (optional luaSupport lua) ++
    (optional pngSupport libpng) ++
    (optional recoilSupport recoil.dev) ++
    (optional tiffSupport libtiff) ++
    (optionals ttfSupport [ freetype fontconfig sdl.SDL_ttf ]);

  postPatch = let
    recoilVer = recoil.dev.version;
  in ''
    ln -s ${recoil.dev}/include/recoil.h src
    ln -s ${recoil.dev}/src/recoil.c src
    mkdir -p 3rdparty/recoil-${recoilVer}
    ln -s ${recoil.dev}/src/recoil.c 3rdparty/recoil-${recoilVer}
  '';

  buildFlags = [ "grafx2" "htmldoc" ];

  makeFlags = [ "PREFIX=$(out)" "API=${multimediaApi}" ] ++
    (optional (!x11Support) "NO_X11=1") ++
    (optional joystickSupport "USE_JOYSTICK=1") ++
    (optional (!layersSupport) "NOLAYERS=1") ++
    (optional (!luaSupport) "NOLUA=1") ++
    (optional (!pngSupport) "__no_pnglib__=1") ++
    (optional (!recoilSupport) "NORECOIL=1") ++
    (optional (!tiffSupport) "__no_tifflib__=1") ++
    (optional (!ttfSupport) "NOTTF=1");

  installPhase = ''
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    # Old bash empty array hack
    # shellcheck disable=SC2086
    local flagsArray=(
        $makeFlags ''${makeFlagsArray+"''${makeFlagsArray[@]}"}
        $installFlags ''${installFlagsArray+"''${installFlagsArray[@]}"}
        ''${installTargets:-install}
    )

    echoCmd 'install flags' "''${flagsArray[@]}"
    (cd src && make Makefile "''${flagsArray[@]}")
    unset flagsArray

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share/doc/grafx2
    cp -rt $out/share/doc/grafx2 doc/html/*
  '';

  preFixup = ''
    mv $out/bin/grafx2{-${multimediaApi},}
  '';

  meta = with stdenv.lib; {
    description = "Bitmap paint program inspired by the Amiga programs Deluxe Paint and Brilliance";
    longDescription = ''
      GrafX2 is a bitmap paint program inspired by the Amiga programs Deluxe
      Paint and Brilliance. Specialized in 256-color drawing, it includes a very
      large number of tools and effects that make it particularly suitable for
      pixel art, game graphics, and generally any detailed graphics painted with a
      mouse.
    '';
    homepage = http://grafx2.tk;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bb010g zoomulator ];
    platforms = with platforms; unix;
  };
}
