{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, zig
, curl
, SDL2
, SDL2_image
, SDL2_ttf
}:

stdenv.mkDerivation rec {
  pname = "mepo";
  version = "0.2";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = pname;
    rev = version;
    hash = "sha256-ECq748GpjOjvchzAWlGA7H7HBvKNxY9d43+PTOWopiM=";
  };

  nativeBuildInputs = [ pkg-config zig ];

  buildInputs = [ curl SDL2 SDL2_image SDL2_ttf ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR
    zig build -Drelease-safe=true -Dcpu=baseline

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    zig build test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 zig-out/bin/mepo -t $out/bin
    install -Dm755 scripts/mepo_* $out/bin

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
