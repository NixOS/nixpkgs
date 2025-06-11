{ runCommand, cosmopolitan }:

let
  cosmocc =
    runCommand "cosmocc-${cosmopolitan.version}"
      {
        pname = "cosmocc";
        inherit (cosmopolitan) version;

        passthru.tests = {
          cc = runCommand "c-test" { } ''
            ${cosmocc}/bin/cosmocc ${./hello.c}
            ./a.out > $out
          '';
        };

        meta = cosmopolitan.meta // {
          description = "compilers for Cosmopolitan C/C++ programs";
        };
      }
      ''
        mkdir -p $out/bin
        install ${cosmopolitan.dist}/tool/scripts/{cosmocc,cosmoc++} $out/bin
        sed 's|/opt/cosmo\([ /]\)|${cosmopolitan.dist}\1|g' -i $out/bin/*
      '';
in
cosmocc
