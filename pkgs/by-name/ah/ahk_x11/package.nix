{ lib
, stdenv
, fetchFromGitHub
, crystal
, copyDesktopItems
, linkFarm
, fetchgit

, gtk3
, libxkbcommon
, xorg
, libnotify
, gobject-introspection # needed to build gi-crystal
, openbox
, xvfb-run
, xdotool

, buildDevTarget ? false # the dev version prints debug info
} :

let
  pname = "ahk_x11";
  version = "1.0.3-unstable-2024-03-22"; # 1.0.3 doesn't build

  crystalLib = linkFarm "ahk_x11-lib" (lib.mapAttrsToList (name: value: {
    inherit name;
    path = fetchgit value;
  }) (import ./shards.nix));

  inherit (xorg) libXinerama libXtst libXext libXi;

in crystal.buildCrystalPackage {

  inherit pname version;
  src = fetchFromGitHub {
    owner = "phil294";
    repo = "AHK_X11";
    rev = "264553dc283c0b3833a1f24de8d38951acd5c273"; # version;
    hash = "sha256-N/0WZGydABDiPs2zd0cAowjuSuuXmOsvz+G8uGHh3js=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed -i 's/shards install --frozen//' Makefile
    sed -i 's/git submodule update --init/true/' Makefile
    sed -i -r 's|(\./bin/ahk_x11 tests\.ahk)|XDG_CACHE_HOME=''${TMPDIR} HOME=''${TMPDIR} xvfb-run --auto-display openbox --startup "\1"|' Makefile
    sed -i -r 's| (\S+) (\''$\(DESTDIR\S+/)''$| -t \2 \1|' Makefile
  '';

  configurePhase = ''
    runHook preConfigure

    cp -r -L ${crystalLib} lib
    chmod -R +w lib
    cp shard.lock lib/.shards.info

    runHook postConfigure
  '';

  # It needs this specific version of gi-crystal. Building it here.
  preBuild = ''
    mkdir bin
    cd lib/gi-crystal
    crystal build -o ../../bin/gi-crystal src/generator/main.cr
    cd ../..
  '';

  postBuild = lib.optionalString buildDevTarget ''
    mv bin/ahk_x11.dev bin/ahk_x11
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  buildInputs = [ gtk3 libxkbcommon libXinerama libXtst libXext libXi libnotify ];
  nativeBuildInputs = [ copyDesktopItems gobject-introspection ];
  nativeCheckInputs = [ xvfb-run openbox xdotool ];

  buildTargets = if buildDevTarget then "bin/ahk_x11.dev" else "bin/ahk_x11";
  checkTarget = "test-dev";

  # The tests fail with AtSpi failure. This means it lacks assistive technologies:
  # https://github.com/phil294/AHK_X11?tab=readme-ov-file#accessibility
  # I don't know how to fix it for xvfb and openbox.
  doCheck = false;

  meta = with lib; {
    description = "AutoHotkey for X11";
    homepage = "https://phil294.github.io/AHK_X11";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ulysseszhan ];
    platforms = platforms.linux;
    mainProgram = "ahk_x11";
  };
}
