lib: self:

let
  inherit (lib) elemAt;

  matchForgeRepo = builtins.match "(.+)/(.+)";

  fetchers = lib.mapAttrs (_: fetcher: self.callPackage fetcher { }) {
    github =
      { fetchFromGitHub }:
      {
        repo ? null,
        ...
      }:
      { sha256, commit, ... }:
      let
        m = matchForgeRepo repo;
      in
      assert m != null;
      fetchFromGitHub {
        owner = elemAt m 0;
        repo = elemAt m 1;
        rev = commit;
        inherit sha256;
      };

    gitlab =
      { fetchFromGitLab }:
      {
        repo ? null,
        ...
      }:
      { sha256, commit, ... }:
      let
        m = matchForgeRepo repo;
      in
      assert m != null;
      fetchFromGitLab {
        owner = elemAt m 0;
        repo = elemAt m 1;
        rev = commit;
        inherit sha256;
      };

    git = (
      { fetchgit }:
      {
        url ? null,
        ...
      }:
      { sha256, commit, ... }:
      (fetchgit {
        rev = commit;
        inherit sha256 url;
      }).overrideAttrs(_: {
        GIT_SSL_NO_VERIFY = true;
      })
    );

    bitbucket =
      { fetchhg }:
      {
        repo ? null,
        ...
      }:
      { sha256, commit, ... }:
      fetchhg {
        rev = commit;
        url = "https://bitbucket.com/${repo}";
        inherit sha256;
      };

    hg =
      { fetchhg }:
      {
        url ? null,
        ...
      }:
      { sha256, commit, ... }:
      fetchhg {
        rev = commit;
        inherit sha256 url;
      };

    sourcehut =
      { fetchzip }:
      {
        repo ? null,
        ...
      }:
      { sha256, commit, ... }:
      fetchzip {
        url = "https://git.sr.ht/~${repo}/archive/${commit}.tar.gz";
        inherit sha256;
      };

    codeberg =
      { fetchzip }:
      {
        repo ? null,
        ...
      }:
      { sha256, commit, ... }:
      fetchzip {
        url = "https://codeberg.org/${repo}/archive/${commit}.tar.gz";
        inherit sha256;
      };
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
        broken = error != null;
      in
      if hasSource then
        lib.nameValuePair ename (
          self.callPackage ({ melpaBuild, fetchurl, ... }@pkgargs:
          melpaBuild {
            inherit pname ename;
            inherit (sourceArgs) commit;
            version = lib.optionalString (version != null)
              (lib.concatStringsSep "." (map toString
                # Hack: Melpa archives contains versions with parse errors such as [ 4 4 -4 413 ] which should be 4.4-413
                # This filter method is still technically wrong, but it's computationally cheap enough and tapers over the issue
                (builtins.filter (n: n >= 0) version)));
            # TODO: Broken should not result in src being null (hack to avoid eval errors)
            src = if (sha256 == null || broken) then null else
              fetchers.${fetcher} args sourceArgs;
            recipe = if commit == null then null else
              fetchurl {
                name = pname + "-recipe";
                url = "https://raw.githubusercontent.com/melpa/melpa/${commit}/recipes/${ename}";
                inherit sha256;
              };
            packageRequires = lib.optionals (deps != null)
              (map (dep: pkgargs.${dep} or self.${dep} or null)
                   deps);
            meta = (sourceArgs.meta or {}) // {
              inherit broken;
            };
          }
        ) {}
      )
    else
      null;

}
