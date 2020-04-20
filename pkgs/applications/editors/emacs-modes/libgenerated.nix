lib: self:

let

    fetcherGenerators = { repo ? null
                        , url ? null
                        , ... }:
                        { sha256
                        , commit
                        , ...}: {
      github = self.callPackage ({ fetchFromGitHub }:
        fetchFromGitHub {
          owner = lib.head (lib.splitString "/" repo);
          repo = lib.head (lib.tail (lib.splitString "/" repo));
          rev = commit;
          inherit sha256;
        }
      ) {};
      gitlab = self.callPackage ({ fetchFromGitLab }:
        fetchFromGitLab {
          owner = lib.head (lib.splitString "/" repo);
          repo = lib.head (lib.tail (lib.splitString "/" repo));
          rev = commit;
          inherit sha256;
        }
      ) {};
      git = self.callPackage ({ fetchgit }:
        fetchgit {
          rev = commit;
          inherit sha256 url;
        }
      ) {};
      bitbucket = self.callPackage ({ fetchhg }:
        fetchhg {
          rev = commit;
          url = "https://bitbucket.com/${repo}";
          inherit sha256;
        }
      ) {};
      hg = self.callPackage ({ fetchhg }:
        fetchhg {
          rev = commit;
          inherit sha256 url;
        }
      ) {};
    };

in {

  melpaDerivation = variant:
                      { ename, fetcher
                      , commit ? null
                      , sha256 ? null
                      , ... }@args:
      let
        sourceArgs = args.${variant};
        version = sourceArgs.version or null;
        deps = sourceArgs.deps or null;
        error = sourceArgs.error or args.error or null;
        hasSource = lib.hasAttr variant args;
        pname = builtins.replaceStrings [ "@" ] [ "at" ] ename;
        broken = ! isNull error;
      in
      lib.nameValuePair ename (if hasSource then (
        self.callPackage ({ melpaBuild, fetchurl, ... }@pkgargs:
          melpaBuild {
            inherit pname;
            ename = ename;
            version = if isNull version then "" else
              lib.concatStringsSep "." (map toString version);
            # TODO: Broken should not result in src being null (hack to avoid eval errors)
            src = if (isNull sha256 || broken) then null else
              lib.getAttr fetcher (fetcherGenerators args sourceArgs);
            recipe = if isNull commit then null else
              fetchurl {
                name = pname + "-recipe";
                url = "https://raw.githubusercontent.com/melpa/melpa/${commit}/recipes/${ename}";
                inherit sha256;
              };
            packageRequires = lib.optionals (! isNull deps)
              (map (dep: pkgargs.${dep} or self.${dep} or null)
                   deps);
            meta = (sourceArgs.meta or {}) // {
              inherit broken;
            };
          }
        ) {}
      ) else null);

}
