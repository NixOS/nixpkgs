{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libftdi,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "infnoise";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "leetronics";
    repo = "infnoise";
    rev = "e80ddd78085abf3d06df2e0d8c08fd33dade78eb";
    sha256 = "sha256-9MKG1InkV+yrQPBTgi2gZJ3y9Fokb6WbxuAnM7n7FyA=";
  };

  patches = [
    # Patch makefile so we can set defines from the command line instead of it depending on .git
    ./makefile.patch

    # Fix getc return type
    (fetchpatch {
      url = "https://github.com/leetronics/infnoise/commit/7ed7014e14253311c07e530c8f89f1c8f4705c2b.patch";
      sha256 = "sha256-seB/fJaxQ/rXJp5iPtnobXXOccQ2KUAk6HFx31dhOhs=";
    })
  ];

  GIT_COMMIT = finalAttrs.src.rev;
  GIT_VERSION = finalAttrs.version;
  GIT_DATE = "2019-08-12";

  buildInputs = [ libftdi ];

  makefile = "Makefile.linux";
  makeFlags = [ "PREFIX=$(out)" ];
  postPatch = ''
    cd software
    substituteInPlace init_scripts/infnoise.service --replace "/usr/local" "$out"
  '';

  postInstall = ''
    make -C tools
    find ./tools/ -executable -type f -exec \
      sh -c "install -Dm755 {} $out/bin/infnoise-\$(basename {})" \;
  '';

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    homepage = "https://github.com/leetronics/infnoise";
    description = "Driver for the Infinite Noise TRNG";
    longDescription = ''
      The Infinite Noise TRNG is a USB key hardware true random number generator.
      It can either provide rng for userland applications, or provide rng for the OS entropy.
    '';
    license = licenses.cc0;
    maintainers = with maintainers; [
      StijnDW
      zhaofengli
    ];
    platforms = platforms.linux;
  };
})
