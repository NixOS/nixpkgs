{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  python3,
  m4,
  cairo,
  libX11,
  mesa,
  mesa_glu,
  ncurses,
  tcl,
  tcsh,
  tk,
  fixDarwinDylibNames,
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

  nativeBuildInputs =
    [
      python3
      git
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      fixDarwinDylibNames
    ];

  buildInputs = [
    cairo
    libX11
    m4
    mesa
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

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fix dylib paths on macOS
    install_name_tool -add_rpath ${mesa.out}/lib $out/lib/magic/tcl/tclmagic.dylib
    install_name_tool -add_rpath ${mesa_glu.out}/lib $out/lib/magic/tcl/tclmagic.dylib
    install_name_tool -add_rpath ${mesa.out}/lib $out/lib/magic/tcl/magicexec
    install_name_tool -add_rpath ${mesa_glu.out}/lib $out/lib/magic/tcl/magicexec
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";

  meta = with lib; {
    description = "VLSI layout tool written in Tcl";
    homepage = "http://opencircuitdesign.com/magic/";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
