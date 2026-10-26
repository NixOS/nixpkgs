{
  lib,
  stdenv,
  fetchFromCodeberg,
  jdupes,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjodycode";
  version = "4.2";

  outputs = [
    "out"
    "man"
    "dev"
  ];

  src = fetchFromCodeberg {
    owner = "jbruchon";
    repo = "libjodycode";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OLvxHNJvCutw83CwkEQi7V2AimJ9odqw3Sfa52CL7i8=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  env.PREFIX = placeholder "out";

  enableParallelBuilding = true;

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
