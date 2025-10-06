{
  bzip2,
  elfutils,
  fetchFromGitHub,
  lib,
  stdenv,
  zlib,
  zstd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "makedumpfile";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "makedumpfile";
    repo = "makedumpfile";
    tag = finalAttrs.version;
    hash = "sha256-Hs7qNtPD/9iPTS+sr208OQTDW1dk2Q7mv/4D6dQkGC4=";
  };

  buildInputs = [
    bzip2
    zstd
    elfutils
    zlib
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '/usr/share' "/share"
  '';

  makeFlags = [
    "USEZSTD=on"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
    "LINKTYPE=dynamic"
  ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "SBINDIR=bin"
  ];

  postInstall = ''
    ln -s bin $out/sbin
  '';

  meta = {
    maintainers = with lib.maintainers; [ Scrumplex ];
    mainProgram = "makedumpfile";
  };
})
