{
  lib,
  stdenv,
  fetchFromGitea,
  fetchpatch,
  jdupes,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjodycode";
  version = "4.1";

  outputs = [
    "out"
    "man"
    "dev"
  ];

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jbruchon";
    repo = "libjodycode";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IBOCl5iFxKwanA28JG4wEzy9tNb6TznKK8RJET8CtSY=";
  };

  patches = [
    # Fix linux build failure, drop after 4.1 release.
    (fetchpatch {
      name = "linux-build-fix.patch";
      url = "https://codeberg.org/jbruchon/libjodycode/commit/07294bbfd6c3c4be42c40c9ed81eebb5cd3d83a0.patch";
      hash = "sha256-qgP8MgGenGebM7n5zpPJ1WTsYUTCZwcWUloUKToc1eo=";
    })
  ];

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  env.PREFIX = placeholder "out";

  passthru.tests = {
    inherit jdupes;
  };

  meta = {
    description = "Shared code used by several utilities written by Jody Bruchon";
    homepage = "https://codeberg.org/jbruchon/libjodycode";
    changelog = "https://codeberg.org/jbruchon/libjodycode/src/branch/master/CHANGES.txt";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pbsds ];
  };
})
