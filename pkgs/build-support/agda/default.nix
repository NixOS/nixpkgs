# Builder for Agda packages. Mostly inspired by the cabal builder.

{ stdenv, Agda, glibcLocales
, writeShellScriptBin
, extension ? (self: super: {})
}:

with stdenv.lib.strings;

let
  defaults = self : {
    # There is no Hackage for Agda so we require src.
    inherit (self) src name;

    isAgdaPackage = true;

    buildInputs = [ Agda ] ++ self.buildDepends;
    buildDepends = [];

    buildDependsAgda = stdenv.lib.filter
      (dep: dep ? isAgdaPackage && dep.isAgdaPackage)
      self.buildDepends;
    buildDependsAgdaShareAgda = map (x: x + "/share/agda") self.buildDependsAgda;

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

    # FIXME: `dirOf self.everythingFile` is what we really want, not hardcoded "./"
    includeDirs = self.buildDependsAgdaShareAgda
                  ++ self.sourceDirectories ++ self.topSourceDirectories
                  ++ [ "." ];
    buildFlags = stdenv.lib.concatMap (x: ["-i" x]) self.includeDirs;

    agdaWithArgs = "${Agda}/bin/agda ${toString self.buildFlags}";

    buildPhase = ''
      runHook preBuild
      ${self.agdaWithArgs} ${self.everythingFile}
      runHook postBuild
    '';

    installPhase = let
      srcFiles = self.sourceDirectories
                 ++ map (x: x + "/*") self.topSourceDirectories;
    in ''
      runHook preInstall
      mkdir -p $out/share/agda
      cp -pR ${concatStringsSep " " srcFiles} $out/share/agda
      runHook postInstall
    '';

    passthru = {
      env = stdenv.mkDerivation {
        name = "interactive-${self.name}";
        inherit (self) LANG LOCALE_ARCHIVE;
        AGDA_PACKAGE_PATH = concatMapStrings (x: x + ":") self.buildDependsAgdaShareAgda;
        buildInputs = let
          # Makes a wrapper available to the user. Very useful in
          # nix-shell where all dependencies are -i'd.
          agdaWrapper = writeShellScriptBin "agda" ''
            exec ${self.agdaWithArgs} "$@"
          '';
        in [agdaWrapper] ++ self.buildDepends;
      };
    };
  };
in
{ mkDerivation = args: let
      super = defaults self // args self;
      self  = super // extension self super;
    in stdenv.mkDerivation self;
}
