{
  lib,
  gccStdenv,
  fetchFromGitHub,
  cmake,
  libpthread-stubs,
  icu,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "peaclock";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "octobanana";
    repo = "peaclock";
    tag = finalAttrs.version;
    hash = "sha256-JkRku5lrieyTAXgkF/B9O3+VQwvu3Xga2+tdSPXbApU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libpthread-stubs
    icu
  ];

  meta = {
    description = "Clock, timer, and stopwatch for the terminal";
    homepage = "https://octobanana.com/software/peaclock";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ djanatyn ];
    mainProgram = "peaclock";
  };
})
