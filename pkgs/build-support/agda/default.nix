# Builder for Agda packages. Mostly inspired by the cabal builder.
#
# Contact: stdenv.lib.maintainers.fuuzetsu

{ stdenv, Agda, glibcLocales
, writeScriptBin
, extension ? (self: super: {})
}:

let
  optionalString = stdenv.lib.optionalString;
  filter = stdenv.lib.filter;
  concatMapStringsSep = stdenv.lib.strings.concatMapStringsSep;
  concatMapStrings = stdenv.lib.strings.concatMapStrings;
  unwords = stdenv.lib.strings.concatStringsSep " ";
  mapInside = xs: unwords (map (x: x + "/*") xs);
in
{ mkDerivation = args:
    let
      postprocess = x: x // {
        sourceDirectories = filter (y: !(y == null)) x.sourceDirectories;
        propagatedBuildInputs = filter (y : ! (y == null)) x.propagatedBuildInputs;
        propagatedUserEnvPkgs = filter (y : ! (y == null)) x.propagatedUserEnvPkgs;
        extraBuildFlags = filter (y : ! (y == null)) x.extraBuildFlags;
        everythingFile = if x.everythingFile == "" then "Everything.agda" else x.everythingFile;
      };

      defaults = self : {
        # There is no Hackage for Agda so we require src.
        inherit (self) src name;

        buildInputs = [ Agda ] ++ self.buildDepends;
        buildDepends = [];
        # Not much choice here ;)
        LANG = "en_US.UTF-8";
        LOCALE_ARCHIVE = optionalString stdenv.isLinux "${glibcLocales}/lib/locale/locale-archive";

        everythingFile = "Everything.agda";

        propagatedBuildInputs = self.buildDepends ++ self.buildTools;
        propagatedUserEnvPkgs = self.buildDepends;

        # Immediate source directories under which modules can be found.
        sourceDirectories = [ ];

        # This is used if we have a top-level element that only serves
        # as the container for the source and we only care about its
        # contents. The directories put here will have their
        # *contents* copied over as opposed to sourceDirectories which
        # would make a direct copy of the whole thing.
        topSourceDirectories = [ "src" ];

        buildTools = [];

        # Extra stuff to pass to the Agda binary.
        extraBuildFlags = [ "-i ." ];
        buildFlags = let r = map (x: "-i " + x + "/share/agda") self.buildDepends;
                         d = map (x : "-i " + x) (self.sourceDirectories ++ self.topSourceDirectories);
                     in unwords (r ++ d ++ self.extraBuildFlags);

        # We expose this as a mere convenience for any tools.
        AGDA_PACKAGE_PATH = concatMapStrings (x: x + ":") self.buildDepends;

        # Makes a wrapper available to the user. Very useful in
        # nix-shell where all dependencies are -i'd.
        agdaWrapper = writeScriptBin "agda" ''
          ${Agda}/bin/agda ${self.buildFlags} "$@"
        '';

        # configurePhase is idempotent
        configurePhase = ''
          eval "$preConfigure"
          export AGDA_PACKAGE_PATH=${self.AGDA_PACKAGE_PATH};
          export PATH="${self.agdaWrapper}/bin:$PATH"
          eval "$postConfigure"
        '';

        buildPhase = ''
          eval "$preBuild"
          ${Agda}/bin/agda ${self.buildFlags} ${self.everythingFile}
          eval "$postBuild"
        '';

        installPhase = ''
          eval "$preInstall"
          mkdir -p $out/share/agda
          cp -pR ${unwords self.sourceDirectories} ${mapInside self.topSourceDirectories} $out/share/agda
          eval "$postInstall"
        '';
      };
    in stdenv.mkDerivation
         (postprocess (let super = defaults self // args self;
                           self  = super // extension self super;
                       in self));
}