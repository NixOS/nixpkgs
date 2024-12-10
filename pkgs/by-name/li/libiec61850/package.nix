{
  cmake,
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libiec61850";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "mz-automation";
    repo = "libiec61850";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KFUqeDe90wrqMueD8AYgB1scl6OZkKW2z+oV9wREF3k=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Open-source library for the IEC 61850 protocols";
    homepage = "https://libiec61850.com/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ stv0g ];
    platforms = lib.platforms.unix;
  };
})
