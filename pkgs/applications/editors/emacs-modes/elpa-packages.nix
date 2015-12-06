pkgs: with pkgs;

let

  inherit (stdenv.lib) makeScope mapAttrs;

  json = builtins.readFile ./elpa-packages.json;
  manifest = builtins.fromJSON json;

  mkPackage = self: name: recipe:
    let drv =
          { elpaBuild, stdenv, fetchurl }:
          let fetch = { inherit fetchurl; }."${recipe.fetch.tag}"
                or (abort "emacs-${name}: unknown fetcher '${recipe.fetch.tag}'");
              args = builtins.removeAttrs recipe.fetch [ "tag" ];
              src = fetch args;
          in elpaBuild {
            pname = name;
            inherit (recipe) version;
            inherit src;
            deps =
              let lookupDep = d:
                    self."${d}" or (abort "emacs-${name}: missing dependency ${d}");
              in map lookupDep recipe.deps;
            meta = {
              homepage = "http://elpa.gnu.org/packages/${name}.html";
              license = stdenv.lib.licenses.free;
            };
          };
    in self.callPackage drv {};

  packages = self:
    let
      elpaPackages = mapAttrs (mkPackage self) manifest;

      elpaBuild = import ../../../build-support/emacs/melpa.nix {
        inherit (pkgs) lib stdenv fetchurl texinfo;
        inherit (self) emacs;
      };
    in elpaPackages // { inherit elpaBuild elpaPackages; };

in makeScope pkgs.newScope packages
