{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  wxwidgets_3_2,
  boost,
  firebird,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.9.15";
  pname = "flamerobin";

  src = fetchFromGitHub {
    owner = "mariuz";
    repo = "flamerobin";
    tag = finalAttrs.version;
    hash = "sha256-s11bX8rYlkxf0vhcq36V/w9wJXaC/JymAtiAvEJ6pxA=";
  };

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs --build update-revision-info.sh
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    wxwidgets_3_2
    boost
    firebird
  ];

  meta = {
    description = "Database administration tool for Firebird RDBMS";
    homepage = "https://github.com/mariuz/flamerobin";
    license = lib.licenses.AND [
      lib.licenses.mit
      (lib.licenses.mkLicense {
        shortName = "ibpp";
        fullName = "IBPP License v1.1";
        url = "https://ibpp.sourceforge.io/license";
      })
      lib.licenses.lgpl2Only
    ];
    maintainers = with lib.maintainers; [ uralbash ];
    platforms = lib.platforms.unix;
    mainProgram = "flamerobin";
  };
})
