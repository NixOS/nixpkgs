{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libbsd,
  libmd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtree";
  version = "1.0.0-unstable-2022-05-19";

  src = fetchFromGitHub {
    owner = "jashank";
    repo = "mtree-portable";
    rev = "fea79f387c592cede1217b8d019549d8d6b42235";
    hash = "sha256-VBm5oDquYvR2TeOlSRAzOGSQ3L8K3Ci8aZxJ8sg1PEU=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libbsd
    libmd
  ];

  patches = [
    ./0001-Port-to-Linux-with-libbsd-and-libmd.patch
  ];

  meta = {
    description = "Utility for mapping and checking directory hierarchies";
    homepage = "https://github.com/jashank/mtree-portable";
    changelog = "https://github.com/jashank/mtree-portable/blob/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.philiptaron ];
    mainProgram = "mtree";
    platforms = lib.platforms.linux;
  };
})
