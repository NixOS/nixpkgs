pkgs: with pkgs;

let

  inherit (stdenv.lib) makeScope mapAttrs;

  json = builtins.readFile ./melpa-stable-packages.json;
  manifest = builtins.fromJSON json;

  mkPackage = self: name: recipe:
    let drv =
          { melpaBuild, stdenv, fetchurl }:
          let fetch = { inherit fetchurl; }."${recipe.fetch.tag}"
                or (abort "emacs-${name}: unknown fetcher '${recipe.fetch.tag}'");
              args = builtins.removeAttrs recipe.fetch [ "tag" ];
              src = fetch args;
          in melpaBuild {
            pname = name;
            inherit (recipe) version;
            inherit src;
            deps =
              let lookupDep = d:
                    self."${d}" or (abort "emacs-${name}: missing dependency ${d}");
              in map lookupDep recipe.deps;
            meta = {
              homepage = "http://stable.melpa.org/#/${name}";
              license = stdenv.lib.licenses.free;
            };
          };
    in self.callPackage drv {};

  packages = self:
    let
      melpaStablePackages = mapAttrs (mkPackage self) manifest;

      melpaBuild = import ../../../build-support/emacs/melpa.nix {
        inherit (pkgs) lib stdenv fetchurl texinfo;
        inherit (self) emacs;
      };
    in melpaStablePackages // { inherit melpaBuild melpaStablePackages; };

in makeScope pkgs.newScope packages
