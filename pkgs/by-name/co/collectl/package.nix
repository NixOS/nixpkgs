{
  lib,
  callPackage,
}:

let
  pname = "collectl";
  version = "4.3.1";

  meta = with lib; {
    description = "Performance monitoring tool for Linux systems";
    longDescription = ''
      Collectl is a light-weight performance monitoring tool capable of reporting
      interactively as well as logging to disk. It reports statistics on cpu, disk,
      infiniband, lustre, memory, network, nfs, process, quadrics, slabs and more
      in easy to read format.
    '';
    homepage = "https://collectl.sourceforge.net/";
    downloadPage = "https://sourceforge.net/projects/collectl/files/";
    license = with licenses; [
      artistic1
      gpl1Plus
    ];
    maintainers = with maintainers; [ loberman ];
    platforms = platforms.linux;
    mainProgram = "collectl";
  };

  passthru = {
    updateScript = ./update.sh;
  };

in
callPackage ./linux.nix {
  inherit
    pname
    version
    meta
    passthru
    ;
}
