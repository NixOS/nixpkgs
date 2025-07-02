{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  python3,
  m4,
  cairo,
  libX11,
  mesa_glu,
  ncurses,
  tcl,
  tcsh,
  tk,
}:

stdenv.mkDerivation rec {
  pname = "magic-vlsi";
  version = "8.3.530";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "magic";
    tag = "${version}";
    sha256 = "sha256-OQPOEDcU0BuGdI7+saOTntosa8+mQcGbZuwzIlvRBSk=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    python3
    git
  ];

  buildInputs = [
    cairo
    libX11
    m4
    mesa_glu
    ncurses
    tcl
    tcsh
    tk
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tcl=${tcl}"
    "--with-tk=${tk}"
    "--disable-werror"
  ];

  postPatch = ''
    patchShebangs scripts/*
  '';

  postInstall = ''
    # Fix necessary files missing in sys directory
    mkdir -p $out/lib/magic/sys

    shopt -s nullglob

    for techfile in scmos/*.tech; do
      install -Dm644 "$techfile" $out/lib/magic/sys/$(basename "$techfile")
    done

    for dstylefile in scmos/*.dstyle; do
      install -Dm644 "$dstylefile" $out/lib/magic/sys/$(basename "$dstylefile")
    done

    for cmapfile in scmos/*.cmap; do
      install -Dm644 "$cmapfile" $out/lib/magic/sys/$(basename "$cmapfile")
    done
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  meta = with lib; {
    description = "VLSI layout tool written in Tcl";
    homepage = "http://opencircuitdesign.com/magic/";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
