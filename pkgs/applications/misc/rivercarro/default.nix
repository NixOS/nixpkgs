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
  version = "0.1.2";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "07md837ki0yln464w8vgwyl3yjrvkz1p8alxlmwqfn4w45nqhw77";
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

