/*

# Updating

To update the list of packages from ELPA,

1. Clone https://github.com/ttuegel/emacs2nix
2. Run `./elpa-packages.sh` from emacs2nix
3. Copy the new elpa-packages.json file into Nixpkgs
4. `git commit -m "elpa-packages $(date -Idate)"`

*/

{ fetchurl, lib, stdenv, texinfo }:

let

  inherit (lib) makeScope mapAttrs;

  json = builtins.readFile ./elpa-packages.json;
  manifest = builtins.fromJSON json;

  mkPackage = self: name: recipe:
    let drv =
          { elpaBuild, stdenv, fetchurl }:
          let
            unknownFetcher =
              abort "emacs-${name}: unknown fetcher '${recipe.fetch.tag}'";
            fetch =
              { inherit fetchurl; }."${recipe.fetch.tag}"
              or unknownFetcher;
            args = builtins.removeAttrs recipe.fetch [ "tag" ];
            src = fetch args;
          in elpaBuild {
            pname = name;
            inherit (recipe) version;
            inherit src;
            packageRequires =
              let lookupDep = d: self."${d}" or null;
              in map lookupDep recipe.deps;
            meta = {
              homepage = "http://elpa.gnu.org/packages/${name}.html";
              license = stdenv.lib.licenses.free;
            };
          };
    in self.callPackage drv {};

in

self:

  let
    super = mapAttrs (mkPackage self) manifest;

    elpaBuild = import ../../../build-support/emacs/melpa.nix {
      inherit fetchurl lib stdenv texinfo;
      inherit (self) emacs;
    };

    markBroken = pkg: pkg.override {
      elpaBuild = args: self.elpaBuild (args // {
        meta = (args.meta or {}) // { broken = true; };
      });
    };

    elpaPackages = super // {
      ace-window = markBroken super.ace-window;
      ada-mode = markBroken super.ada-mode;
      beacon = markBroken super.beacon;
      bug-hunter = markBroken super.bug-hunter;
      company-math = markBroken super.company-math;
      company-statistics = markBroken super.company-statistics;
      context-coloring = markBroken super.context-coloring;
      dict-tree = markBroken super.dict-tree;
      el-search = markBroken super.el-search;
      ergoemacs-mode = markBroken super.ergoemacs-mode;
      exwm = markBroken super.exwm;
      gnugo = markBroken super.gnugo;
      iterators = markBroken super.iterators;
      midi-kbd = markBroken super.midi-kbd;
      stream = markBroken super.stream;
      tNFA = markBroken super.tNFA;
      trie = markBroken super.trie;
      xelb = markBroken super.xelb;
    };
  in elpaPackages // { inherit elpaBuild elpaPackages; }
