{
  lib,
  stdenv,
  fetchgit,
  gettext,
  python3,
  elfutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsystemtap";
  version = "5.6";

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-4COcitD0EwfxRcXIfIFVvwgIsgCfOULvhyWl23z/mxg=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    gettext
    python3
  ];

  buildInputs = [ elfutils ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -r includes/* $out/include/

    runHook postInstall
  '';

  meta = {
    description = "Statically defined probes development files";
    homepage = "https://sourceware.org/systemtap/";
    license = lib.licenses.bsd3;
    platforms = elfutils.meta.platforms or lib.platforms.unix;
    badPlatforms = elfutils.meta.badPlatforms or [ ];
    maintainers = [ lib.maintainers.workflow ];
  };
})
