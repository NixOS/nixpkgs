{ lib
, stdenv
, fetchFromSourcehut
, zig
, wayland
, wayland-protocols
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "stacktile";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = pname;
    fetchSubmodules = true;
    # rev = "v${version}";
    rev = "62f06ac9e436a574c7193d03bf90bb3055de828c";
    sha256 = "sha256-Cv62ZoQk1N32L4UIs7YTNa7tDTTOWfSRPHqQxndDw7U=";
  };

  nativeBuildInputs = [ pkg-config zig wayland ];
  buildInputs = [ wayland-protocols ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline -Dman-pages --prefix $out install
    runHook postInstall
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://sr.ht/~leon_plickat/stacktile";
    description = "A layout generator for river Wayland compositor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edrex ];
  };
}

