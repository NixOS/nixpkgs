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
, util-linux
, inconsolata-nerdfont
, menuChoice
, bemenu
, dmenu
, xdotool
, directfb
, libGL
, vis
, gnome
, withGpsd ? false, gpsd
, withGeoclue ? false, geoclue2-with-demo-agent
}:

let
  menuInputs = {
    bemenu = [ bemenu ];
    dmenu = [ dmenu xdotool ];
    framebuffer = [ directfb libGL vis busybox ];
    zenity = [ gnome.zenity ];
  }.${menuChoice};
in stdenv.mkDerivation rec {
  pname = "mepo";
  version = "1.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = pname;
    rev = version;
    hash = "sha256-x1g81J/p7P0w8MOt5Xsmshg/xSl57hBkweZMlsLLWfM=";
  };

  nativeBuildInputs = [ pkg-config zig makeWrapper ];

  buildInputs = [
    curl SDL2 SDL2_gfx SDL2_image SDL2_ttf inconsolata-nerdfont jq ncurses
  ] ++ menuInputs;

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

    zig build -Drelease-safe=true -Dcpu=baseline --prefix $bin install
    install -d $man/share/man/man1
    $bin/bin/mepo -docman > $man/share/man/man1/mepo.1

    runHook postInstall
  '';

  postInstall = let
    inherit (lib) concatStrings makeBinPath optional;
  in concatStrings ((optional withGeoclue ''
    substituteInPlace $bin/bin/mepo_ui_menu_user_pin_updater.sh\
      --replace /usr/libexec/geoclue-2.0 ${geoclue2-with-demo-agent}/libexec/geoclue-2.0
  '') ++ [ ''
    substituteInPlace $bin/bin/mepo_ui_central_menu.sh\
      --replace "grep mepo_" "grep '^\.mepo_\|^mepo_'"\
      --replace " ls " " ls -a " #circumvent wrapping for script detection
    wrapProgram $bin/bin/mepo_dl.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ jq ncurses curl busybox util-linux ]}
    wrapProgram $bin/bin/mepo_ui_central_menu.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ busybox findutils ]}
    wrapProgram $bin/bin/mepo_ui_helper_menu.sh\
      --set PATH ${makeBinPath (menuInputs ++ [ findutils busybox ])}
    wrapProgram $bin/bin/mepo_ui_helper_pref_pan.sh\
      --suffix PATH : ${makeBinPath [ busybox ]}
    wrapProgram $bin/bin/mepo_ui_menu_dbg_queuedownloadinteractive.sh\
      --suffix PATH : $bin/bin
    wrapProgram $bin/bin/mepo_ui_menu_pin_editor.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ busybox ]}
    wrapProgram $bin/bin/mepo_ui_menu_pref_fontsize.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ busybox ]}
    wrapProgram $bin/bin/mepo_ui_menu_pref_url.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ busybox findutils ]}
    wrapProgram $bin/bin/mepo_ui_menu_pref_zoom.sh\
      --suffix PATH : ${makeBinPath [ busybox ]}
    wrapProgram $bin/bin/mepo_ui_menu_reposition_nominatim.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ busybox curl jq ]}
    wrapProgram $bin/bin/mepo_ui_menu_route_graphhopper.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ busybox curl jq]}
    wrapProgram $bin/bin/mepo_ui_menu_route_overpassrelation.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ busybox curl findutils jq ]}
    wrapProgram $bin/bin/mepo_ui_menu_search_nominatim.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ busybox curl jq ]}
    wrapProgram $bin/bin/mepo_ui_menu_search_overpass.sh\
      --suffix PATH : $bin/bin:${makeBinPath [ busybox curl jq ]}
      wrapProgram $bin/bin/mepo_ui_menu_user_pin_updater.sh\
      --suffix PATH : ${makeBinPath ([ busybox curl jq ] ++ (optional withGpsd gpsd))}
    wrapProgram $bin/bin/mepo --suffix PATH : $bin/bin
  '' ]);

  outputs = [ "bin" "out" "man" ];

  meta = with lib; {
    description = "Fast, simple, and hackable OSM map viewer";
    longDescription = ''
      # Menu Systems
      Mepo supports multiple programs for displaying the menu. The default here is zenity.
      If you prefer to use another, chose the `mepo-dmenu`, `mepo-bemenu` or `mepo-framebuffer`
      packages, respectively.

      # Location
      For getting Location data, Mepo accepts 3 Backends:
      - GPSD
      - Geoclue
      - Mozilla Location Services

      Both GPSD and Geoclue require extra setup, that's why they're both set to false by default.

      For GPSD, you need to enable (and configure) GPSD. This means your device must have a GPS sensor.
      If you're on NixOS, see the
      [gpsd configuration options](https://search.nixos.org/options?type=packages&query=services.gpsd)
      NixOS provides.

      To configure geoclue, you need to install the geoclue service and allow the `where-am-i`
      program mepo uses. To do that, on NixOS:
      ```nix
      services.geoclue2 = {
        enable = true;
        appConfig.where-am-i = {
          isAllowed = true;
          isSystem = false;
        };
      };

      ```
      Finally, you need to override this package, setting `withGeoclue`
      and/or `withGpsd` to true, respectively, e.g. list your mepo package
      of choice as `(mepo.override { withGpsd = true; withGeoclue = true; })`.
    '';
    homepage = "https://sr.ht/~mil/mepo/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir McSinyx laalsaas ];
    platforms = platforms.linux;
  };
}
