{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, zig
, curl
, SDL2
, SDL2_gfx
, SDL2_image
, SDL2_ttf
}:

stdenv.mkDerivation rec {
  pname = "mepo";
  version = "0.3";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = pname;
    rev = version;
    hash = "sha256-B7BOAFhiOTILUdzh49hTMrNNHZpCNRDLW2uekXyptqQ=";
  };

  nativeBuildInputs = [ pkg-config zig ];

  buildInputs = [ curl SDL2 SDL2_gfx SDL2_image SDL2_ttf ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    zig build test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    zig build -Drelease-safe=true -Dcpu=baseline --prefix $out install

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast, simple, and hackable OSM map viewer";
    homepage = "https://sr.ht/~mil/mepo/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # See https://github.com/NixOS/nixpkgs/issues/86299
  };
}
