{ lib
, stdenv
, fetchFromSourcehut
<<<<<<< HEAD
=======
, pkg-config
, zig
, makeWrapper
, busybox
, curl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, SDL2
, SDL2_gfx
, SDL2_image
, SDL2_ttf
<<<<<<< HEAD
, busybox
, curl
, findutils
, geoclue2-with-demo-agent
, gpsd
, jq
, makeWrapper
, ncurses
, pkg-config
, util-linux
, xwininfo
, zenity
, zig_0_11
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mepo";
  version = "1.2.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "mepo";
    rev = finalAttrs.version;
    hash = "sha256-sxN7yTnk3KDAkP/d3miKa2bEgB3AUaf9/M9ajJyRt3g=";
  };

  nativeBuildInputs = [
    pkg-config
    zig_0_11.hook
    makeWrapper
  ];

  buildInputs = [
    curl
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_ttf
    jq
    ncurses
  ];

  doCheck = true;

  postInstall = ''
    install -d $out/share/man/man1
    $out/bin/mepo -docman > $out/share/man/man1/mepo.1
  '';

  postFixup = ''
=======
, findutils
, jq
, ncurses
, gnome
, xorg
, util-linux
, gpsd
, geoclue2-with-demo-agent
}:

stdenv.mkDerivation rec {
  pname = "mepo";
  version = "1.1";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = pname;
    rev = version;
    hash = "sha256-OIZ617QLjiTiDwcsn0DnRussYtjDkVyifr2mdSqA98A=";
  };

  nativeBuildInputs = [ pkg-config zig makeWrapper ];

  buildInputs = [
    curl SDL2 SDL2_gfx SDL2_image SDL2_ttf jq ncurses
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    zig build test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    zig build -Drelease-safe=true -Dcpu=baseline --prefix $out install
    install -d $out/share/man/man1
    $out/bin/mepo -docman > $out/share/man/man1/mepo.1

    runHook postInstall
  '';

  postInstall = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace $out/bin/mepo_ui_menu_user_pin_updater.sh \
      --replace /usr/libexec/geoclue-2.0 ${geoclue2-with-demo-agent}/libexec/geoclue-2.0
    substituteInPlace $out/bin/mepo_ui_central_menu.sh \
      --replace "grep mepo_" "grep '^\.mepo_\|^mepo_'" \
      --replace " ls " " ls -a " #circumvent wrapping for script detection
    for program in $out/bin/* ; do
      wrapProgram $program \
<<<<<<< HEAD
        --suffix PATH : $out/bin:${lib.makeBinPath ([
          busybox
          curl
          findutils
          gpsd
          jq
          ncurses
          util-linux
          xwininfo
          zenity
        ])}
    done
  '';

  meta = {
    homepage = "https://mepo.milesalan.com";
    description = "Fast, simple, and hackable OSM map viewer";
    longDescription = ''
      Mepo is a fast, simple, and hackable OSM map viewer for desktop & mobile
      Linux devices (like the PinePhone, Librem 5, postmarketOS devices etc.)
      and both environment's various user interfaces (Wayland & X
      inclusive). Environments supported include Phosh, Sxmo, Plasma Mobile,
      desktop X, and desktop Wayland. Mepo works both offline and online,
      features a minimalist both touch/mouse and keyboard compatible interface,
      and offers a UNIX-philosophy inspired underlying design, exposing a
      powerful command language called Mepolang capable of being scripted to
      provide things like custom bounding-box search scripts, bookmarks, and
      more.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir McSinyx laalsaas ];
    platforms = lib.platforms.linux;
  };
})
=======
        --suffix PATH : $out/bin:${lib.makeBinPath ([ jq ncurses curl busybox findutils util-linux gpsd gnome.zenity xorg.xwininfo ])}
    done
  '';

  meta = with lib; {
    description = "Fast, simple, and hackable OSM map viewer";
    longDescription = ''
      It is recommended to use the corresponding NixOS module.
    '';

    homepage = "https://mepo.milesalan.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir McSinyx laalsaas ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
