{
  lib,
  stdenv,
  fetchFromGitea,
  jdupes,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjodycode";
  version = "4.0";

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
    hash = "sha256-2G6jh+eVwri3RINiFxrc7xwoGTTxlGKsEQMu9YxWSzY=";
  };

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
