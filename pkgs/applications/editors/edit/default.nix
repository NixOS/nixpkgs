{ lib
, stdenv
, fetchgit
, cwebbin
, libX11
, libXft
, ncurses
, pkg-config
, unzip
}:

stdenv.mkDerivation {
  pname = "edit";
  version = "unstable-2021-04-05";

  src = fetchgit {
    url = "git://c9x.me/ed.git";
    rev = "bc24e3d4f716b0afacef559f952c40f0be5a1c58";
    hash = "sha256-DzQ+3B96+UzQqL3lhn0DfYmZy2LOANtibj1e1iVR+Jo=";
  };

  nativeBuildInputs = [
    cwebbin
    pkg-config
    unzip
  ];

  buildInputs = [
    libX11
    libXft
    ncurses
  ];

  preBuild = ''
    ctangle vicmd.w
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 obj/edit -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "A relaxing mix of Vi and ACME";
    homepage = "https://c9x.me/edit";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ AndersonTorres vrthra ];
    platforms = lib.platforms.unix;
    mainProgram = "edit";
  };
}
