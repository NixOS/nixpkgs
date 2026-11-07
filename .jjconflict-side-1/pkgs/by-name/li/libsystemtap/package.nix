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
  version = "5.5";

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-olN98hjIYZmQvI7Fn1v5ZwRl7yaCAPRGr2g33oMq7VQ=";
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
