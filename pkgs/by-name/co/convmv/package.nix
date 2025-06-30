{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "convmv";
  version = "2.06";

  outputs = [
    "bin"
    "man"
    "out"
  ];

  src = fetchzip {
    url = "https://www.j3e.de/linux/convmv/convmv-${finalAttrs.version}.tar.gz";
    hash = "sha256-36UPh+eZBT/J2rkvOcHeqkVKSl4yO9GJp/BxWGDrgGU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    perl
  ];

  buildInputs = [
    perl
    perlPackages.EncodeHanExtra
    perlPackages.EncodeIMAPUTF7
    perlPackages.EncodeJIS2K
  ];

  makeFlags = [
    "PREFIX=${placeholder "bin"}"
    "MANDIR=${placeholder "man"}/share/man"
  ];

  checkTarget = "test";

  # testsuite.tar contains filenames that aren't valid UTF-8. Extraction of
  # testsuite.tar will fail as APFS enforces that filenames are valid UTF-8.
  doCheck = !stdenv.hostPlatform.isDarwin;

  prePatch =
    lib.optionalString finalAttrs.finalPackage.doCheck ''
      tar -xf testsuite.tar
    ''
    + ''
      patchShebangs --host .
    '';

  dontPatchShebangs = true;

  postFixup = ''
    wrapProgram "$bin/bin/convmv" --prefix PERL5LIB : "$PERL5LIB"
  '';

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
