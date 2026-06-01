{
  lib,
  stdenv,
  fetchFromSourcehut,
  pkg-config,
  scdoc,
  libx11,
  cairo,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lesbar";
  version = "1.1.0";

  src = fetchFromSourcehut {
    owner = "~salmiak";
    repo = "lesbar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uggIoO6rgotkLi6lSJTR4d3NtidXsAC1Kjay9YsT9ps=";
  };

  nativeBuildInputs = [
    pkg-config
    scdoc
  ];

  buildInputs = [
    libx11
    cairo
    pango
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Programming language agnostic view layer for creating desktop widgets and status bars";
    homepage = "https://git.sr.ht/~salmiak/lesbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpentland ];
    platforms = lib.platforms.linux;
    mainProgram = "lesbar";
  };
})
