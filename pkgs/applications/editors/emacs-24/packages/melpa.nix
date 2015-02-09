# generic builder for Emacs packages

{ stdenv, fetchurl, emacs, texinfo
, extension ? (self : super : {})
}:

let
  enableFeature         = stdenv.lib.enableFeature;
  versionOlder          = stdenv.lib.versionOlder;
  optional              = stdenv.lib.optional;
  optionals             = stdenv.lib.optionals;
  optionalString        = stdenv.lib.optionalString;
  filter                = stdenv.lib.filter;
  
  packageBuild          = fetchurl {
    url = https://raw.githubusercontent.com/milkypostman/melpa/12a862e5c5c62ce627dab83d7cf2cca6e8b56c47/package-build.el;
    sha256 = "1nviyyprypz7nmam9rwli4yv3kxh170glfbznryrp4czxkrjjdhk";
  };

in

{
  mkDerivation =
    args : # arguments for the individual package, can modify the defaults
    let # Stuff happening after the user preferences have been processed. We remove
        # internal attributes and strip null elements from the dependency lists, all
        # in the interest of keeping hashes stable.
        postprocess =
          x : x // {
                buildInputs           = filter (y : ! (y == null)) x.buildInputs;
                propagatedBuildInputs = filter (y : ! (y == null)) x.propagatedBuildInputs;
                propagatedUserEnvPkgs = filter (y : ! (y == null)) x.propagatedUserEnvPkgs;
                doCheck               = x.doCheck;
              };

        defaults =
          self : { # self is the final version of the attribute set

            # pname should be defined by the client to be the package basename
            # version should be defined by the client to be the package version

            # fname is the internal full name of the package
            fname = "${self.pname}-${self.version}";

            # name is the external full name of the package; usually we prefix
            # all packages with emacs- to avoid name clashes for libraries;
            # if that is not desired (for applications), name can be set to
            # fname.
            name = "emacs-${self.pname}-${self.version}";


            buildInputs = [emacs texinfo] ++ self.packageRequires;

            propagatedBuildInputs = self.packageRequires;

            propagatedUserEnvPkgs = self.packageRequires;

            packageRequires = [];

            doCheck = false;

            files = [];

            setupHook = ./setup-hook.sh;

            fileSpecs = [ "*.el" "*.el.in" "dir"
                          "*.info" "*.texi" "*.texinfo"
                          "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        ];

            targets = stdenv.lib.concatStringsSep " " 
                        (if self.files == []
                         then self.fileSpecs
                         else self.files);

            buildPhase = ''
              eval "$preBuild"

              emacs --batch -Q -l $packageBuild -l ${./melpa2nix.el} \
                -f melpa2nix-build-package \
                ${self.pname} ${self.version} ${self.targets}

              eval "$postBuild"
            '';

            installPhase = ''
              eval "$preInstall"

              emacs --batch -Q -l $packageBuild -l ${./melpa2nix.el} \
                -f melpa2nix-install-package \
                ${self.fname}.* $out/share/emacs/site-lisp/elpa

              eval "$postInstall"
            '';

            # We inherit stdenv and emacs so that they can be used
            # in melpa derivations.
            inherit stdenv emacs texinfo packageBuild;
          };
    in
    stdenv.mkDerivation (postprocess (let super = defaults self // args self;
                                          self  = super // extension self super;
                                      in self));
}
