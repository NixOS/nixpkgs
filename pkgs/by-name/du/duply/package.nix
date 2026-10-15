{
  lib,
  stdenv,
  fetchurl,
  coreutils,
  python3,
  duplicity,
  gawk,
  gnupg,
  bash,
  gnugrep,
  txt2man,
  makeWrapper,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "duply";
  version = "2.5.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/ftplicity/duply%20%28simple%20duplicity%29/2.5.x/duply_${finalAttrs.version}.tgz";
    hash = "sha256-DSSnjfbcgWIuWaA+4h7d/0HqpDoXqkJOyGapYX4rtP0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ txt2man ];

  postPatch = "patchShebangs .";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man1"
    install -vD duply "$out/bin"
    wrapProgram "$out/bin/duply" --prefix PATH : \
        ${lib.makeBinPath [
          coreutils
          python3
          duplicity
          gawk
          gnupg
          bash
          gnugrep
          txt2man
          which
        ]}
    "$out/bin/duply" txt2man > "$out/share/man/man1/duply.1"

    runHook postInstall
  '';

  meta = {
    description = "Shell front end for the duplicity backup tool";
    mainProgram = "duply";
    longDescription = ''
      Duply is a shell front end for the duplicity backup tool
      https://www.nongnu.org/duplicity. It greatly simplifies its usage by
      implementing backup job profiles, batch commands and more. Who says
      secure backups on non-trusted spaces are no child's play?
    '';
    homepage = "https://duply.net/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.bjornfor ];
    platforms = lib.platforms.unix;
  };
})
