{
  lib,
  stdenv,
  fetchgit,
  gettext,
  python3,
  elfutils,
}:

stdenv.mkDerivation {
  pname = "libsystemtap";
  version = "5.1";

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "release-5.1";
    hash = "sha256-3rhDllsgYGfh1gb5frUrlkzdz57A6lcvBELtgvb5Q7M=";
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

  meta = with lib; {
    description = "Statically defined probes development files";
    homepage = "https://sourceware.org/systemtap/";
    license = licenses.bsd3;
    platforms = elfutils.meta.platforms or platforms.unix;
    badPlatforms = elfutils.meta.badPlatforms or [ ];
    maintainers = [ lib.maintainers.farlion ];
  };
}
