{
  stdenv,
  lib,
  fetchFromGitHub,
  boost,
  cmake,
  db,
}:
stdenv.mkDerivation {
  pname = "benzene";
  version = "0-unstable-2022-12-18";

  src = fetchFromGitHub {
    owner = "cgao3";
    repo = "benzene-vanilla-cmake";
    rev = "95614769bafc9850a3cc54974660bb1795db6086";
    hash = "sha256-3DX/OVjKXyeOmO6P6iz1FTkNQ0n7vUFkKQ5Ac+7t3l4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    db
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '-DABS_TOP_SRCDIR="''${top_srcdir}"' '-DABS_TOP_SRCDIR="$ENV{out}"' \
      --replace-fail '-DDATADIR="''${pkgdatadir}"' '-DDATADIR="$ENV{out}/share"'
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/mohex/mohex $out/bin/mohex
    cp src/wolve/wolve $out/bin/wolve
    cp -r ../share $out/share/
    runHook postInstall
  '';

  meta = {
    description = "Software for playing and solving the game of Hex";
    homepage = "https://github.com/cgao3/benzene-vanilla-cmake";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ eilvelia ];
  };
}
