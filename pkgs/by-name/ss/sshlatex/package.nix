{
  lib,
  stdenv,
  fetchFromGitHub,
  inotify-tools,
  openssh,
  perl,
  gnutar,
  bash,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sshlatex";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "iblech";
    repo = "sshlatex";
    rev = finalAttrs.version;
    hash = "sha256-+NBO4W8Qjx7Eu5hkHQGcxlpbu66M9XFGUuuToyOCSk0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      binPath = lib.makeBinPath [
        openssh
        perl
        gnutar
        bash
        inotify-tools
      ];
    in
    ''
      mkdir -p $out/bin
      cp sshlatex $out/bin
      wrapProgram $out/bin/sshlatex --prefix PATH : "${binPath}"
    '';

  meta = {
    description = "Collection of hacks to efficiently run LaTeX via ssh";
    longDescription = ''
      sshlatex is a tool which uploads LaTeX source files to a remote, runs
      LaTeX there, and streams the resulting PDF file to the local host.
      Because sshlatex prestarts LaTeX with the previous run's preamble,
      thereby preloading the required LaTeX packages, it is also useful in a
      purely local setting.
    '';
    homepage = "https://github.com/iblech/sshlatex";
    license = lib.licenses.gpl3Plus; # actually dual-licensed gpl3Plus | lppl13cplus
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.iblech ];
    mainProgram = "sshlatex";
  };
})
