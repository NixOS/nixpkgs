{ pkgs }:

rec {
  shellEnv = homeDirectory: pkgs.writeTextFile {
    name = "clojure-nix-locker.shell-env";
    text = ''
          export HOME="${homeDirectory}"
          export JAVA_TOOL_OPTIONS="-Duser.home=${homeDirectory}"
        '';
    meta = {
      description = ''
            Can be sourced in shell scripts to export environment
            variables so that `clojure` uses the locked dependencies.
          '';
    };
  };
  wrapPrograms = homeDirectory: name: paths:
    let script = pkgs.lib.concatMapStrings (path: ''
        makeWrapper "${path}" "$out/bin/$(basename "${path}")" \
          --run "source ${shellEnv homeDirectory}"
      '')
      paths;
    in
      pkgs.runCommandNoCC name { buildInputs = [ pkgs.makeWrapper ]; } ''
          mkdir -p $out/bin
          ${script}
        '';
  wrapClojure = homeDirectory: clojure:
    wrapPrograms homeDirectory "locked-clojure" ["${clojure}/bin/clojure"
                                                 "${clojure}/bin/clj"];
}
