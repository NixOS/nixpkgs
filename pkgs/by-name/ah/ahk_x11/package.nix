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
  version = "1.0.3-unstable-2024-03-30"; # 1.0.3 doesn't build

  inherit (xorg) libXinerama libXtst libXext libXi;

in crystal.buildCrystalPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "phil294";
    repo = "AHK_X11";
    rev = "047a89722f9680b2b753dee59e74a2d05e746849";
    hash = "sha256-wVKHut1Z3kNVOmkBvQ3X1rW31DH1nL3tN3fED8OiOdM=";
    fetchSubmodules = true;
  };

  postPatch = ''
    t="./bin/ahk_x11 tests.ahk"
    substituteInPlace Makefile \
      --replace-fail 'shards install --frozen' "" \
      --replace-fail "''$t" 'XDG_CACHE_HOME=''${TMPDIR} HOME=''${TMPDIR} xvfb-run --auto-display openbox --startup "''$t"'
  '';

  shardsFile = ./shards.nix;
  copyShardDeps = true;

  preBuild = ''
    mkdir bin
    cd lib/gi-crystal
    shards build -Dpreview_mt --release --no-debug
    cd ../..
    cp lib/gi-crystal/bin/gi-crystal bin
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

  meta = {
    description = "AutoHotkey for X11";
    homepage = "https://phil294.github.io/AHK_X11";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.linux;
    mainProgram = "ahk_x11";
  };
}
