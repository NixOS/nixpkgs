# Builder for Agda packages. Mostly inspired by the Idris builder.
#
# Contacts: stdenv.lib.maintainers.fuuzetsu
#           stdenv.lib.maintainers.siddharthist

{ stdenv, Agda, callPackage, glibcLocales, writeScriptBin
, extension ? (self: super: {})
}:

with stdenv.lib.strings;

let
  withPackages = packages: callPackage ./with-packages.nix {
    inherit Agda;
    packages = packages;
  };
  defaults = self : {
    inherit (self) name;

    isAgdaLibrary = true;

    buildDependsAgda = stdenv.lib.filter
      (dep: dep ? isAgdaLibrary && dep.isAgdaLibrary)
      self.buildDepends;

    # The version of Agda which will automatically include all our libraries
    agda-with-packages = withPackages self.buildDependsAgda;

    buildInputs = [ self.agda-with-packages ] ++ self.buildDepends;

    buildDepends = [];

    # Not much choice here ;)
    LANG = "en_US.UTF-8";
    LOCALE_ARCHIVE = stdenv.lib.optionalString
      stdenv.isLinux
      "${glibcLocales}/lib/locale/locale-archive";

    everythingFile = "Everything.agda";

    propagatedBuildInputs = self.buildDependsAgda;
    propagatedUserEnvPkgs = self.buildDependsAgda;

    # Immediate source directories under which modules can be found.
    sourceDirectories = [ ];

    # This is used if we have a top-level element that only serves
    # as the container for the source and we only care about its
    # contents. The directories put here will have their
    # *contents* copied over as opposed to sourceDirectories which
    # would make a direct copy of the whole thing.
    topSourceDirectories = [ "src" ];

    extraAgdaFlags = [ ];

    # FIXME: `dirOf self.everythingFile` is what we really want, not hardcoded "./"
    includeDirs = self.sourceDirectories ++ self.topSourceDirectories ++ [ "." ];
    buildFlags = concatStringsSep " " (map (x: "-i " + x) self.includeDirs);

    buildPhase = ''
      ${self.agda-with-packages}/bin/agda ${self.buildFlags} ${self.everythingFile}
    '';

    installPhase = let
      srcFiles = self.sourceDirectories
                 ++ map (x: x + "/*") self.topSourceDirectories;
    in ''
      mkdir -p $out/share/agda
      cp -pR ${concatStringsSep " " srcFiles} $out/share/agda
    '';
  };
in
{
  inherit withPackages;
  mkDerivation = args:
    let super = defaults self // args self;
        self  = super // extension self super;
    in stdenv.mkDerivation self;
}
