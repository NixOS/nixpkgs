{
  lib,
  stdenv,
  autoreconfHook,
  bison,
  fetchFromGitHub,
  flex,
  ncurses,
  pkg-config,
}:
let
  version = "6.9";
in
stdenv.mkDerivation {
  pname = "kbuild-standalone";
  inherit version;

  src = fetchFromGitHub {
    owner = "WangNan0";
    repo = "kbuild-standalone";
    tag = "v${version}";
    hash = "sha256-CsHRn91RmDWa4xBnQqH0F63Qsos1q/iKbLtMQ7ehHnc=";
  };

  strictDeps = true;

  buildInputs = [
    ncurses
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
  ];

  preBuild = ''
    mkdir -p $out/{lib/pkgconfig,share}

    patchShebangs kbuild/_fixdep
    cp kbuild-standalone.pc $out/lib/pkgconfig/
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$out/lib/pkgconfig"

    cp -r kbuild/ $out/share/kbuild-standalone/
  '';

  meta = {
    description = "Standalone kconfig and kbuild";
    homepage = "https://github.com/WangNan0/kbuild-standalone";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ _3442 ];
  };
}
