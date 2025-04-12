{
  lib,
  stdenv,
  fetchzip,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "convmv";
  version = "2.05";

  outputs = [
    "out"
    "man"
  ];

  src = fetchzip {
    url = "https://www.j3e.de/linux/convmv/convmv-${finalAttrs.version}.tar.gz";
    hash = "sha256-ts9xAPRGUoS0XBRTmpb+BlGW1hmGyUs+rQLyUEgiZ54=";
  };

  strictDeps = true;

  nativeBuildInputs = [ perl ];

  buildInputs = [ perl ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "MANDIR=${placeholder "man"}/share/man"
  ];

  checkTarget = "test";

  # testsuite.tar contains filenames that aren't valid UTF-8. Extraction of
  # testsuite.tar will fail as APFS enforces that filenames are valid UTF-8.
  doCheck = !stdenv.hostPlatform.isDarwin;

  prePatch =
    lib.optionalString finalAttrs.doCheck ''
      tar -xf testsuite.tar
    ''
    + ''
      patchShebangs --host .
    '';

  dontPatchShebangs = true;

  meta = with lib; {
    description = "Converts filenames from one encoding to another";
    downloadPage = "https://www.j3e.de/linux/convmv/";
    license = with licenses; [
      gpl2Only
      gpl3Only
    ];
    maintainers = with maintainers; [ al3xtjames ];
    mainProgram = "convmv";
    platforms = platforms.unix;
  };
})
