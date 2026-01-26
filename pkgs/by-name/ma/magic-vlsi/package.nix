{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gitMinimal,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "magic-vlsi";
  version = "8.3.573";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "magic";
    tag = finalAttrs.version;
    hash = "sha256-P5qfMsn3DGHjeF7zsZWeG9j38C6j5UEwUqGyjaEVO1E=";
    leaveDotGit = true;
  };

  patches = [
    (fetchpatch {
      name = "fix-buffer-overflow-runstats.patch";
      url = "https://github.com/RTimothyEdwards/magic/commit/6a07bc172b4bdae8bc22f51905194cdd427912cc.patch";
      hash = "sha256-QPVl+SfUWj51u/G+EjTCVQZdG7tTdOlEFN/hS7E1Ojg=";
    })

    (fetchpatch {
      name = "neuer-fix-name.patch";
      url = "https://github.com/RTimothyEdwards/magic/commit/a70ca249c3a4e7a256a4482bd887452267c8cd52.patch";
      hash = "sha256-sNQDz4/hBtwJeDrOCe+LfJkuaB0zRzX7w1aDv8ZD7Pw=";
    })
  ];

  nativeBuildInputs = [
    python3
    gitMinimal
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

  # gnu89 is needed for GCC 15 that is more strict about K&R style prototypes
  env.NIX_CFLAGS_COMPILE = "-std=gnu89 -Wno-implicit-function-declaration";
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";

  meta = {
    description = "VLSI layout tool written in Tcl";
    homepage = "http://opencircuitdesign.com/magic/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
})
