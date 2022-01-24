{ pkgs
, stdenv
, lib
, jre
, fetchFromGitHub
, writeShellScript
, runCommand
, imagemagick
}:

# To test:
# $(nix-build --no-out-link -E 'with import <nixpkgs> {}; jupyter.override { definitions = { clojure = clojupyter.definition; }; }')/bin/jupyter-notebook

let
  cljdeps = import ./deps.nix { inherit pkgs; };
  classp  = cljdeps.makeClasspaths {};

  shellScript = writeShellScript "clojupyter" ''
    ${jre}/bin/java -cp ${classp} clojupyter.kernel.core "$@"
  '';

  pname = "clojupyter";
  version = "0.3.2";

  meta = with lib; {
    description = "A Jupyter kernel for Clojure";
    homepage = "https://github.com/clojupyter/clojupyter";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasjm ];
    platforms = jre.meta.platforms;
  };

  sizedLogo = size: stdenv.mkDerivation {
    name = "clojupyter-logo-${size}x${size}.png";

    src = fetchFromGitHub {
      owner = "clojupyter";
      repo = "clojupyter";
      rev = "0.3.2";
      sha256 = "1wphc7h74qlm9bcv5f95qhq1rq9gmcm5hvjblb01vffx996vr6jz";
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
  launcher = runCommand "clojupyter" { inherit pname version meta shellScript; } ''
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
