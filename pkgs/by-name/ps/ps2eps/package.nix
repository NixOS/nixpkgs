{
  lib,
  fetchFromGitHub,
  perlPackages,
  substituteAll,
  ghostscript,
  installShellFiles,
}:

perlPackages.buildPerlPackage rec {
  pname = "ps2eps";
  version = "1.70";

  src = fetchFromGitHub {
    owner = "roland-bless";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SPLwsGKLVhANoqSQ/GJ938cYjbjMbUOXkNn9so3aJTA=";
  };
  patches = [
    (substituteAll {
      src = ./hardcode-deps.patch;
      gs = "${ghostscript}/bin/gs";
      # bbox cannot be substituted here because substituteAll doesn't know what
      # will be the $out path of the main derivation
    })
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  configurePhase = "true";

  buildPhase = ''
    runHook preBuild

    make -C src/C bbox
    patchShebangs src/perl/ps2eps
    substituteInPlace src/perl/ps2eps \
      --replace @bbox@ $out/bin/bbox

    runHook postBuild
  '';

  # Override buildPerlPackage's outputs setting
  outputs = [
    "out"
    "man"
  ];
  installPhase = ''
    runHook preInstall

    installManPage \
      doc/ps2eps.1 \
      doc/bbox.1

    install -D src/perl/ps2eps $out/bin/ps2eps
    install -D src/C/bbox $out/bin/bbox

    runHook postInstall
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Calculate correct bounding boxes for PostScript and PDF files";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.doronbehar ];
  };
}
