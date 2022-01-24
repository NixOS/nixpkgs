{ lib
, stdenv
, fetchFromSourcehut
, zig
, river
, wayland
, pkg-config
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "rivercarro";
  version = "0.1.1";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "0h1wvl6rlrpr67zl51x71hy7nwkfd5kfv5p2mql6w5fybxxyqnpm";
  };

  nativeBuildInputs = [
    pkg-config
    river
    scdoc
    wayland
    zig
  ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline -Dman-pages --prefix $out install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~novakane/rivercarro";
    description = "A layout generator for river Wayland compositor, fork of rivertile";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kraem ];
  };
}

