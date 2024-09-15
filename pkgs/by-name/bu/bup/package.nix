{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  pandoc,
  python3,
  git,

  par2Support ? true,
  par2cmdline ? null,
}:

assert par2Support -> par2cmdline != null;

let
  version = "0.33.4";

  pythonDeps =
    with python3.pkgs;
    [
      setuptools
      tornado
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      pyxattr
      pylibacl
      fuse
    ];
in

stdenv.mkDerivation {
  pname = "bup";
  inherit version;

  src = fetchFromGitHub {
    repo = "bup";
    owner = "bup";
    rev = version;
    hash = "sha256-9rWzHONcu4W/JcnDUGPbuGksroODbhdL6bNF+3Dd2ag=";
  };

  buildInputs = [
    git
    python3
  ];
  nativeBuildInputs = [
    pandoc
    perl
    makeWrapper
  ];

  postPatch = "patchShebangs .";

  dontAddPrefix = true;

  makeFlags = [
    "MANDIR=$(out)/share/man"
    "DOCDIR=$(out)/share/doc/bup"
    "BINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib/bup"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-error=implicit-function-declaration -Wno-error=implicit-int";

  postInstall = ''
    wrapProgram $out/bin/bup \
      --prefix PATH : ${lib.makeBinPath [ git par2cmdline ]} \
      --prefix NIX_PYTHONPATH : ${lib.makeSearchPathOutput "lib" python3.sitePackages pythonDeps}
  '';

  meta = with lib; {
    homepage = "https://github.com/bup/bup";
    description = "Efficient file backup system based on the git packfile format";
    mainProgram = "bup";
    license = licenses.gpl2Plus;

    longDescription = ''
      Highly efficient file backup system based on the git packfile format.
      Capable of doing *fast* incremental backups of virtual machine images.
    '';

    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
