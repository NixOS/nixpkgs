{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "acc";
  version = "1.60";

  src = fetchFromGitHub {
    owner = "zdoom";
    repo = "acc";
    rev = finalAttrs.version;
    hash = "sha256-HGF4O4LcMDY4f/ZuBbkvx5Wd86+8Ict624eKTJ88/rQ=";
  };

  patches = [
    # Don't force static builds
    ./disable-static.patch
    (fetchpatch {
      name = "cmake-fix-1";
      url = "https://github.com/ZDoom/acc/commit/a0e7d2437c7f66a2b973537c2e854e2b91cd9c4c.patch";
      hash = "sha256-n+YctiUFYbv6u3ixB5wTsT8KBmearECoUtC74OpoG6c=";
    })
    (fetchpatch {
      name = "cmake-fix-2";
      url = "https://github.com/ZDoom/acc/commit/df6a2735acccad9131ce73fa07506445cfe69ec2.patch";
      hash = "sha256-DFMxZ8/Shv+tBSPXdhaPI1iTi1fbng/IMO//0Jk4Lk4=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    install -D acc $out/bin/acc

    runHook postInstall
  '';

  meta = {
    description = "ACS script compiler for use with ZDoom and Hexen";
    homepage = "https://zdoom.org/wiki/ACC";
    license = lib.licenses.activision;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.all;
    mainProgram = "acc";
  };
})
