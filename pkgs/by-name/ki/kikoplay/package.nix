{
  fetchFromGitHub,
  stdenv,
  lib,
  callPackage,
  libsForQt5,
  makeWrapper,
  qt5,
  mpv,
  lua5_3_compat,
}:
let
  qhttpengine = callPackage ./qhttpengine.nix { };
in
stdenv.mkDerivation rec {
  pname = "kikoplay";
  version = "1.0.3";
  src = fetchFromGitHub {
    owner = "KikoPlayProject";
    repo = "KikoPlay";
    rev = "${version}";
    hash = "sha256-y+sT0aHDvKFNaJIxnGxDXZXUiCzuXVF7FPc8t//RMW4=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    makeWrapper
    qt5.qtwebsockets
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    mpv
    qhttpengine
    qt5.qtbase
    qt5.qtwebsockets
  ];

  strictDeps = true;

  patches = [ ./change-install-path.patch ];

  postPatch = ''
    substituteInPlace KikoPlay.pro \
      --replace-fail "OUTPATH" "$out" \
      --replace-fail "liblua53.a" "${lua5_3_compat}/lib/liblua.so.5.3"

    substituteInPlace kikoplay.desktop \
      --replace-fail "/usr/share/pixmaps/kikoplay.png" "$out/share/pixmaps/kikoplay.png"

    for F in Extension/App/appmanager.cpp Extension/Script/scriptmanager.cpp LANServer/router.cpp; do
      substituteInPlace "$F" --replace-fail "/usr/share/kikoplay/" "$out/share/kikoplay/"
    done
  '';

  qmakeFlags = [ "KikoPlay.pro" ];
  hardeningDisable = [ "format" ];

  # We will append QT wrapper args to our own wrapper
  dontWrapQtApps = true;

  postFixup = ''
    mkdir -p $out/share/kikoplay/extension/script
    cp -r ${
      (fetchFromGitHub {
        owner = "KikoPlayProject";
        repo = "KikoPlayScript";
        rev = "0efa0aa479922ea7881966e3876263ccc3de1cf7";
        hash = "sha256-saRI+/wk90Ldry85dh3PStKVQZjDECtPN58tJftkVJA=";
      })
    }/{bgm_calendar,danmu,library,resource} $out/share/kikoplay/extension/script/
    mkdir -p $out/share/kikoplay/extension/app
    cp -r ${
      (fetchFromGitHub {
        owner = "KikoPlayProject";
        repo = "KikoPlayApp";
        rev = "1e9c0a2e0a0b34ce4f8b97c712afacd85708f848";
        hash = "sha256-ditVnsOHirCw/ve96c0evBYWG+1YQpsQXht7vgto8/o=";
      })
    }/app/* $out/share/kikoplay/extension/app/

    wrapProgram $out/bin/KikoPlay \
      "''${qtWrapperArgs[@]}" \
      --set QT_QPA_PLATFORM xcb \
      --set XDG_SESSION_TYPE x11
  '';

  meta = {
    mainProgram = "KikoPlay";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "More than a Full-Featured Danmu Player";
    homepage = "https://kikoplay.fun";
    license = lib.licenses.gpl3Only;
    # See https://github.com/NixOS/nixpkgs/pull/354929
    broken = stdenv.hostPlatform.isDarwin;
  };
}
