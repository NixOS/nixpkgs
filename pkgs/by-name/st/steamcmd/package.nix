{
  lib,
  stdenv,
  fetchurl,
  steam-run,
  bash,
  coreutils,
  steamRoot ? "~/.local/share/Steam",
}:

stdenv.mkDerivation {
  pname = "steamcmd";
  version = "20180104"; # According to steamcmd_linux.tar.gz mtime

  src = fetchurl {
    url = "https://web.archive.org/web/20240521141411/https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz";
    hash = "sha256-zr8ARr/QjPRdprwJSuR6o56/QVXl7eQTc7V5uPEHHnw=";
  };

  # The source tarball does not have a single top-level directory.
  preUnpack = ''
    mkdir $name
    cd $name
    sourceRoot=.
  '';

  buildInputs = [
    bash
    steam-run
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/steamcmd/linux32
    install -Dm755 steamcmd.sh $out/share/steamcmd/steamcmd.sh
    install -Dm755 linux32/* $out/share/steamcmd/linux32

    mkdir -p $out/bin
    substitute ${./steamcmd.sh} $out/bin/steamcmd \
      --subst-var out \
      --subst-var-by coreutils ${coreutils} \
      --subst-var-by steamRoot "${steamRoot}" \
      --subst-var-by steamRun ${steam-run}
    chmod 0755 $out/bin/steamcmd
  '';

  meta = with lib; {
    homepage = "https://developer.valvesoftware.com/wiki/SteamCMD";
    description = "Steam command-line tools";
    mainProgram = "steamcmd";
    platforms = platforms.linux;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ tadfisher ];
  };
}
