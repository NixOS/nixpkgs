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
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "makedumpfile";
    repo = "makedumpfile";
    tag = finalAttrs.version;
    hash = "sha256-xUYIvNf7Td/PJreuadMTUwy0XaSQVes/9ltrJNiAwVw=";
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
    homepage = "https://github.com/makedumpfile/makedumpfile";
    description = "Make Linux crash dump small by filtering and compressing pages";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ Scrumplex ];
    mainProgram = "makedumpfile";
    platforms = lib.platforms.linux;
  };
})
