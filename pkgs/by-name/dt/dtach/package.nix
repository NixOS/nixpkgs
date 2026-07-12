{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtach";
  version = "0.9";

  src = fetchurl {
    url = "mirror://sourceforge/project/dtach/dtach/${finalAttrs.version}/dtach-${finalAttrs.version}.tar.gz";
    sha256 = "1wwj2hlngi8qn2pisvhyfxxs8gyqjlgrrv5lz91w8ly54dlzvs9j";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/crigler/dtach/commit/6d80909a8c0fd19717010a3c76fec560f988ca48.patch?full_index=1";
      hash = "sha256-v3vToJdSwihiPCSjXjEJghiaynHPTEql3F7URXRjCbM=";
    })
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp dtach $out/bin/dtach
  '';

  meta = {
    homepage = "https://dtach.sourceforge.net/";
    description = "Program that emulates the detach feature of screen";

    longDescription = ''
      dtach is a tiny program that emulates the detach feature of
      screen, allowing you to run a program in an environment that is
      protected from the controlling terminal and attach to it later.
      dtach does not keep track of the contents of the screen, and
      thus works best with programs that know how to redraw
      themselves.
    '';

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "dtach";
  };
})
