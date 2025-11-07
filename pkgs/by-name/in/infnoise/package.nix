{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libftdi,
  testers,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "infnoise";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "leetronics";
    repo = "infnoise";
    rev = "19bb69894724d87b32b7b9b86022bb4b26c919f8";
    sha256 = "sha256-O2P4uOwO7wKLYLufdW3KQeyuFBoQPdSepnTUeq0CSJY=";
  };

  patches = [
    # Patch providing version info at compile time
    (fetchpatch {
      url = "https://github.com/leetronics/infnoise/commit/04d52a975bf78d2aff2bb4c176c286715e1948ba.patch";
      sha256 = "sha256-vtPAR6gCyny9UP+U6/7X8CPEUuMDl7RIyICIwiaWyfc=";
    })
  ];

  GIT_COMMIT = finalAttrs.src.rev;
  GIT_VERSION = finalAttrs.version;
  GIT_DATE = "2023-02-14";

  buildInputs = [ libftdi ];

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  makefile = "Makefile.linux";
  makeFlags = [ "PREFIX=$(out)" ];
  postPatch = ''
    cd software
    substituteInPlace init_scripts/infnoise.service --replace "/usr/local" "$out"
  '';

  postInstall = ''
    make -C tools
    # 2e6cfbe made findlongest executable, but it's a C file
    chmod -x tools/*.c
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
