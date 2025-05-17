{
  pkgs,
  stdenv,
  lib,
  jre,
  fetchFromGitHub,
  writeShellScript,
  runCommand,
  imagemagick,
}:

# Jupyter console:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel clojupyter.definition'

# Jupyter notebook:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter.override { definitions.clojure = clojupyter.definition; }'

let
  cljdeps = import ./deps.nix { inherit pkgs; };
  classp = cljdeps.makeClasspaths { };

  shellScript = writeShellScript "clojupyter" ''
    ${jre}/bin/java -cp ${classp} clojupyter.kernel.core "$@"
  '';

  pname = "clojupyter";
  version = "0.3.3";

  meta = with lib; {
    description = "Jupyter kernel for Clojure";
    homepage = "https://github.com/clojupyter/clojupyter";
    sourceProvenance = with sourceTypes; [ binaryBytecode ]; # deps from maven
    license = licenses.mit;
    maintainers = with maintainers; [ thomasjm ];
    platforms = jre.meta.platforms;
  };

  sizedLogo =
    size:
    stdenv.mkDerivation {
      name = "clojupyter-logo-${size}x${size}.png";

      src = fetchFromGitHub {
        owner = "clojupyter";
        repo = "clojupyter";
        tag = version;
        sha256 = "sha256-BCzcPnLSonm+ELFU4JIIzLPlVnP0VzlrRSGxOd/LFow=";
      };

      buildInputs = [ imagemagick ];

      dontConfigure = true;
      dontInstall = true;

      buildPhase = ''
        convert ./resources/clojupyter/assets/logo-64x64.png -resize ${size}x${size} $out
      '';

      inherit meta;
    };

in

rec {
  launcher =
    runCommand "clojupyter"
      {
        inherit
          pname
          version
          meta
          shellScript
          ;
      }
      ''
        mkdir -p $out/bin
        ln -s $shellScript $out/bin/clojupyter
      '';

  definition = {
    displayName = "Clojure";
    argv = [
      "${launcher}/bin/clojupyter"
      "{connection_file}"
    ];
    language = "clojure";
    logo32 = sizedLogo "32";
    logo64 = sizedLogo "64";
  };
}
