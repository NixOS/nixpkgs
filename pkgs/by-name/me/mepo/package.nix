{
  lib,
  stdenv,
  fetchFromSourcehut,
  SDL2,
  SDL2_gfx,
  SDL2_image,
  SDL2_ttf,
  busybox,
  curl,
  geoclue2-with-demo-agent,
  gpsd,
  jq,
  makeWrapper,
  mobroute,
  ncurses,
  pkg-config,
  util-linux,
  xwininfo,
  zenity,
  zig_0_14,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mepo";
  version = "1.3.4";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "mepo";
    rev = finalAttrs.version;
    hash = "sha256-1NE8lADvcxWGi01kxYW2tCOhnVee+T76ITvwSj6M5DM=";
  };

  nativeBuildInputs = [
    pkg-config
    zig_0_14.hook
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
    install -d $out/share/doc/mepo
    $out/bin/mepo -docmd > $out/share/doc/mepo/documentation.md
  '';

  postFixup = ''
    substituteInPlace $out/bin/mepo_ui_menu_user_pin_updater.sh \
      --replace-fail /usr/libexec/geoclue-2.0 ${geoclue2-with-demo-agent}/libexec/geoclue-2.0
    substituteInPlace $out/bin/mepo_ui_central_menu.sh \
      --replace-fail "grep mepo_" "grep '^\.mepo_\|^mepo_'" \
      --replace-fail " ls " " ls -a " #circumvent wrapping for script detection
    for program in $out/bin/* ; do
      wrapProgram $program \
        --suffix PATH : $out/bin:${
          lib.makeBinPath ([
            busybox
            curl
            gpsd
            jq
            mobroute
            ncurses
            util-linux
            xwininfo
            zenity
          ])
        }
    done
  '';

  meta = {
    homepage = "https://mepo.lrdu.org";
    description = "Fast, simple, and hackable OSM map viewer";
    longDescription = ''
      Mepo is a fast, simple, and hackable OSM map viewer for desktop & mobile
      Linux devices (like the PinePhone, Librem 5, postmarketOS devices etc.)
      and both environment's various user interfaces (Wayland & X
      inclusive). Environments supported include Phosh, Sxmo, Plasma Mobile,
      desktop X, and desktop Wayland. Mepo works both offline and online,
      features a minimalist both touch/mouse and keyboard compatible interface,
      and offers a UNIX-philosophy inspired underlying design, exposing a
      powerful JSON API to allow the user to change & add functionality
      such as adding their own search & routing scripts,
      add arbitrary buttons/keybindings to the UI, and more.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      sikmir
      McSinyx
      laalsaas
    ];
    platforms = lib.platforms.linux;
  };
})
