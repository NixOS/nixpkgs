{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, zig
, makeWrapper
, curl
, SDL2
, SDL2_gfx
, SDL2_image
, SDL2_ttf
, jq
, ncurses
, inconsolata-nerdfont
, dmenu
, xdotool
, bemenu
, withX11 ? false

# transmits user's location without asking first
, geoclueSupport ? false , geoclue2

# transmits user's location without asking first
, reportLocationToMozilla ? false

, gpsdSupport ? true , gpsd
}:

let
  menuInputs = if withX11 then [ dmenu xdotool ] else [ bemenu ];
in stdenv.mkDerivation rec {
  pname = "mepo";
  version = "0.4.2";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = pname;
    rev = version;
    hash = "sha256-k6YXaqB3EwbDPlTvijZf10q+IYwt4/MiqGXL495KIcY=";
  };

  nativeBuildInputs = [ pkg-config zig makeWrapper ];

  buildInputs = [
    curl SDL2 SDL2_gfx SDL2_image SDL2_ttf inconsolata-nerdfont jq ncurses
  ] ++ menuInputs
    ++ lib.optional geoclueSupport geoclue2
    ++ lib.optional gpsdSupport gpsd;

  patches = lib.optionals (!geoclueSupport) [
    ./dont-report-user-location-to-geoclue-without-asking.patch
  ] ++ lib.optionals (!reportLocationToMozilla) [
    ./dont-report-user-location-to-mozilla-without-asking.patch
  ];

  postPatch = lib.optionalString gpsdSupport ''
    substituteInPlace scripts/mepo_ui_menu_user_pin_updater.sh --replace gpspipe ${gpsd}/bin/gpspipe
  '';

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

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/mepo_dl.sh\
      --suffix PATH : ${lib.makeBinPath [ jq ncurses ]}
    wrapProgram $out/bin/mepo_ui_helper_menu.sh\
      --suffix PATH : ${lib.makeBinPath menuInputs}
    for script in $(grep -l jq out/bin/mepo_ui_menu_*.sh); do
      wrapProgram $script --suffix PATH : $out/bin:${lib.makeBinPath [ jq ]}
    done
    for prog in $out/bin/mepo*; do
      if [ ! -f $out/bin/.$(basename $prog)-wrapped ]; then
        wrapProgram $prog --suffix PATH : $out/bin
      fi
    done
  '';

  meta = with lib; {
    description = "Fast, simple, and hackable OSM map viewer";
    homepage = "https://sr.ht/~mil/mepo/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir McSinyx ];
    platforms = platforms.linux;
  };
}
