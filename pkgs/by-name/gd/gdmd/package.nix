{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  replaceVars,
  gdc,
  perl,
}:
stdenvNoCC.mkDerivation {
  pname = "gdmd";
  version = "0.1.0-unstable-2024-05-30";

  src = fetchFromGitHub {
    owner = "D-Programming-GDC";
    repo = "gdmd";
    rev = "dc0ad9f739795f3ce5c69825efcd5d1d586bb013";
    hash = "sha256-Sw8ExEPDvGqGKcM9VKnOI6MGgXW0tAu51A90Wi4qrRE=";
  };

  patches = [
    (replaceVars ./0001-gdc-store-path.diff {
      gdc_dir = "${gdc}/bin";
    })
  ];

  buildInputs = [
    gdc
    perl
  ];

  installFlags = [
    "DESTDIR=$(out)"
    "prefix="
  ];

  preInstall = ''
    install -d $out/bin $out/share/man/man1
  '';

  meta = {
    description = "Wrapper for GDC that emulates DMD's command line";
    homepage = "https://gdcproject.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jtbx ];
    mainProgram = "gdmd";
  };
}
