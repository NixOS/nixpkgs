{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with pkgs.lib;

let
  common = name: package: (import ./make-test-python.nix ({
    inherit name;
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ nequissimus ];
    };

    nodes = {
      scala = { ... }: {
        environment.systemPackages = [ package ];
      };
    };

    testScript = ''
      start_all()

      scala.succeed("scalac -version 2>&1 | grep '^Scala compiler version ${package.version}'")
    '';
  }) { inherit system; });

in with pkgs; {
  scala_2_10  = common "scala_2_10"  scala_2_10;
  scala_2_11  = common "scala_2_11"  scala_2_11;
  scala_2_12  = common "scala_2_12"  scala_2_12;
  scala_2_13  = common "scala_2_13"  scala_2_13;
}
