{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  cairosvg,
  inkscape,
  xcursorgen,
}:
stdenvNoCC.mkDerivation {
  pname = "future-cursors";
  version = "0-unstable-2021-09-18";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "future-cursors";
    rev = "587c14d2f5bd2dc34095a4efbb1a729eb72a1d36";
    hash = "sha256-ziEgMasNVhfzqeURjYJK1l5BeIHk8GK6C4ONHQR7FyY=";
  };

  nativeBuildInputs = [
    cairosvg
    inkscape
    xcursorgen
  ];

  postPatch = ''
    patchShebangs .
  '';

  buildPhase = ''
    runHook preBuild

    # Set up fontconfig cache directory to avoid errors
    export FONTCONFIG_FILE=${inkscape}/etc/fonts/fonts.conf
    export XDG_CACHE_HOME="$TMPDIR/cache"
    mkdir -p "$XDG_CACHE_HOME/fontconfig"
    
    HOME="$NIX_BUILD_ROOT" ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm 755 $out/share/icons
    
    # Only copy directories that were actually built
    for color in "" "-black" "-cyan" "-dark"; do
      if [ -d "dist$color" ]; then
        cp -pr "dist$color/"  "$out/share/icons/Future$color-cursors"
      fi
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Future cursors for linux desktops";
    homepage = "https://github.com/yeyushengfan258/future-cursors";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gambled23 ];
    platforms = platforms.linux;
  };
}
