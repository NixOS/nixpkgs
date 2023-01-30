{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, zig
, makeWrapper
, busybox
, curl
, SDL2
, SDL2_gfx
, SDL2_image
, SDL2_ttf
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
    substituteInPlace $out/bin/mepo_ui_menu_user_pin_updater.sh \
      --replace /usr/libexec/geoclue-2.0 ${geoclue2-with-demo-agent}/libexec/geoclue-2.0
    substituteInPlace $out/bin/mepo_ui_central_menu.sh \
      --replace "grep mepo_" "grep '^\.mepo_\|^mepo_'" \
      --replace " ls " " ls -a " #circumvent wrapping for script detection
    for program in $out/bin/* ; do
      wrapProgram $program \
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
