{ python3 }:

selectPackages:
python3.pkgs.plover.wrapPloverExes (python3.withPackages (ps: [ ps.plover ] ++ selectPackages ps))
