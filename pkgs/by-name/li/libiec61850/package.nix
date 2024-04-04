{ cmake
, lib
, stdenv
, fetchFromGitHub
, gitUpdater
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libiec61850";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "mz-automation";
    repo = "libiec61850";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SwJjjSapNaVOH5g46MiS9BkzI0fKm/P1xYug3OX5XbA=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Open-source library for the IEC 61850 protocols";
    homepage = "https://libiec61850.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ stv0g ];
    platforms = [ "x86_64-linux" ];
  };
})
