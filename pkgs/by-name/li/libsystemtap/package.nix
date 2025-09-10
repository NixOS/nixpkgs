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
  version = "5.3";

  src = fetchgit {
    url = "git://sourceware.org/git/systemtap.git";
    rev = "release-5.3";
    hash = "sha256-W9iJ+hyowqgeq1hGcNQbvPfHpqY0Yt2W/Ng/4p6asxc=";
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
    maintainers = [ lib.maintainers.workflow ];
  };
}
