lib: self:

let

  fetcherGenerators =
    {
      repo ? null,
      url ? null,
      ...
    }:
    {
      sha256,
      commit,
      ...
    }:
    {
      github = self.callPackage (
        { fetchFromGitHub }:
        fetchFromGitHub {
          owner = lib.head (lib.splitString "/" repo);
          repo = lib.head (lib.tail (lib.splitString "/" repo));
          rev = commit;
          inherit sha256;
        }
      ) { };
      gitlab = self.callPackage (
        { fetchFromGitLab }:
        fetchFromGitLab {
          owner = lib.head (lib.splitString "/" repo);
          repo = lib.head (lib.tail (lib.splitString "/" repo));
          rev = commit;
          inherit sha256;
        }
      ) { };
      git = self.callPackage (
        { fetchgit }:
        (fetchgit {
          rev = commit;
          inherit sha256 url;
        }).overrideAttrs
          (_: {
            GIT_SSL_NO_VERIFY = true;
          })
      ) { };
      bitbucket = self.callPackage (
        { fetchhg }:
        fetchhg {
          rev = commit;
          url = "https://bitbucket.com/${repo}";
          inherit sha256;
        }
      ) { };
      hg = self.callPackage (
        { fetchhg }:
        fetchhg {
          rev = commit;
          inherit sha256 url;
        }
      ) { };
      sourcehut = self.callPackage (
        { fetchzip }:
        fetchzip {
          url = "https://git.sr.ht/~${repo}/archive/${commit}.tar.gz";
          inherit sha256;
        }
      ) { };
      codeberg = self.callPackage (
        { fetchzip }:
        fetchzip {
          url = "https://codeberg.org/${repo}/archive/${commit}.tar.gz";
          inherit sha256;
        }
      ) { };
    };

in
{

  melpaDerivation =
    variant:
    {
      ename,
      fetcher,
      commit ? null,
      sha256 ? null,
      ...
    }@args:
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
        self.callPackage (
          { melpaBuild, fetchurl, ... }@pkgargs:
          melpaBuild {
            inherit pname ename commit;
            version = lib.optionalString (version != null) (
              lib.concatStringsSep "." (
                map toString
                  # Hack: Melpa archives contains versions with parse errors such as [ 4 4 -4 413 ] which should be 4.4-413
                  # This filter method is still technically wrong, but it's computationally cheap enough and tapers over the issue
                  (builtins.filter (n: n >= 0) version)
              )
            );
            # TODO: Broken should not result in src being null (hack to avoid eval errors)
            src =
              if (sha256 == null || broken) then
                null
              else
                lib.getAttr fetcher (fetcherGenerators args sourceArgs);
            recipe =
              if commit == null then
                null
              else
                fetchurl {
                  name = pname + "-recipe";
                  url = "https://raw.githubusercontent.com/melpa/melpa/${commit}/recipes/${ename}";
                  inherit sha256;
                };
            packageRequires = lib.optionals (deps != null) (
              map (dep: pkgargs.${dep} or self.${dep} or null) deps
            );
            meta = (sourceArgs.meta or { }) // {
              inherit broken;
            };
          }
        ) { }
      )
    else
      null;

}
