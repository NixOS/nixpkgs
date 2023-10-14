{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, scdoc
, libX11
, cairo
, pango
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

  nativeBuildInputs = [ pkg-config scdoc ];

  buildInputs = [ libX11 cairo pango ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A programming language agnostic view layer for creating desktop widgets and status bars";
    homepage = "https://git.sr.ht/~salmiak/lesbar";
    license = licenses.mit;
    maintainers = with maintainers; [ jpentland ];
    platforms = platforms.linux;
  };
})
