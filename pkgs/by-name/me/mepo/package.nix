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
  findutils,
  geoclue2-with-demo-agent,
  gpsd,
  jq,
  makeWrapper,
  ncurses,
  pkg-config,
  util-linux,
  xwininfo,
  zenity,
  zig_0_12,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mepo";
  version = "1.2.1";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "mepo";
    rev = finalAttrs.version;
    hash = "sha256-Ii5E9TgUxzlVIdkKS/6RtasOETeclMm1yoU86gs4hB8=";
  };

  nativeBuildInputs = [
    pkg-config
    zig_0_12.hook
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
            findutils
            gpsd
            jq
            ncurses
            util-linux
            xwininfo
            zenity
          ])
        }
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
    maintainers = with lib.maintainers; [
      sikmir
      McSinyx
      laalsaas
    ];
    platforms = lib.platforms.linux;
  };
})
