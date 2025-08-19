{
  dosbox,
  fetchzip,
  lib,
  writeShellApplication,
}:

let
  zip = fetchzip {
    name = "keen4.zip";
    url = "https://archive.org/download/msdos_Commander_Keen_4_-_Secret_of_the_Oracle_1991/Commander_Keen_4_-_Secret_of_the_Oracle_1991.zip";
    hash = "sha256-vVfBQArNH1JPUxM5suMe8NK54a+NAMnDhLKxVUOzUgA=";
  };
in
writeShellApplication {
  name = "keen4";

  runtimeInputs = [ dosbox ];

  # Game wants to write in the current directory, but of course we can't
  # let it write in the Nix store.  So create symlinks to the game files
  # in ~/.keen4 and execute game from there.
  text = ''
    mkdir -p "''${HOME:-.}/.keen4"
    cd "''${HOME:-.}/.keen4"
    # avoid linking CONFIG.CK4, which must be writable
    ln -sft . ${zip}/{AUDIO.CK4,EGAGRAPH.CK4,GAMEMAPS.CK4,KEEN4E.EXE}
    trap 'find . -type l -delete' EXIT

    dosbox ./KEEN4E.EXE -fullscreen -exit
  '';

  meta = {
    description = "Commander Keen Episode 4: Secret of the Oracle";
    homepage = "https://web.archive.org/web/20141013080934/http://www.3drealms.com/keen4/index.html";
    downloadPage = "https://archive.org/details/msdos_Commander_Keen_4_-_Secret_of_the_Oracle_1991";
    license = lib.licenses.unfreeRedistributable;
    platforms = dosbox.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ]; # emulated by dosbox, so "bytecode" in a way
    maintainers = with lib.maintainers; [ wolfgangwalther ];
    mainProgram = "keen4";
  };
}
