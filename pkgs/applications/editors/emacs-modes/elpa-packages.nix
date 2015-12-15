pkgs: with pkgs;

let

  inherit (stdenv.lib) makeScope mapAttrs;

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
            deps =
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
      inherit (pkgs) lib stdenv fetchurl texinfo;
      inherit (self) emacs;
    };

    builtin = null;

    markBroken = pkg: pkg.override {
      elpaBuild = args: self.elpaBuild (args // {
        meta = (args.meta or {}) // { broken = true; };
      });
    };
  in super // { inherit elpaBuild; elpaPackage = super; }
