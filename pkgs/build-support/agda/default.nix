# Builder for Agda packages.

{
  stdenv,
  lib,
  self,
  Agda,
  runCommand,
  makeWrapper,
  writeText,
  ghcWithPackages,
  nixosTests,
}:

let
  inherit (lib)
    attrValues
    elem
    filter
    filterAttrs
    isAttrs
    isList
    platforms
    ;

  inherit (lib.strings)
    concatMapStrings
    concatMapStringsSep
    optionalString
    ;

  mkLibraryFile =
    pkgs:
    let
      pkgs' = if isList pkgs then pkgs else pkgs self;
    in
    writeText "libraries" ''
      ${(concatMapStringsSep "\n" (p: "${p}/${p.libraryFile}") pkgs')}
    '';

  withPackages' =
    {
      pkgs,
      ghc ? ghcWithPackages (p: with p; [ ieee754 ]),
    }:
    let
      library-file = mkLibraryFile pkgs;
      pname = "agdaWithPackages";
      version = Agda.version;
    in
    runCommand "${pname}-${version}"
      {
        inherit pname version;
        nativeBuildInputs = [ makeWrapper ];
        passthru = {
          unwrapped = Agda;
          inherit withPackages;
          tests = {
            inherit (nixosTests) agda;
            allPackages = withPackages (filter self.lib.isUnbrokenAgdaPackage (attrValues self));
          };
        };
        # Agda is a split package with multiple outputs; do not inherit them here.
        meta = removeAttrs Agda.meta [ "outputsToInstall" ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper ${Agda.bin}/bin/agda $out/bin/agda \
          --add-flags "--with-compiler=${ghc}/bin/ghc" \
          --add-flags "--library-file=${library-file}"
        ln -s ${Agda.bin}/bin/agda-mode $out/bin/agda-mode
      '';

  withPackages = arg: if isAttrs arg then withPackages' arg else withPackages' { pkgs = arg; };

  extensions = [
    "agda"
    "agda-lib"
    "agdai"
    "lagda"
    "lagda.md"
    "lagda.org"
    "lagda.rst"
    "lagda.tex"
    "lagda.typ"
  ];

  defaults =
    {
      pname,
      meta,
      buildInputs ? [ ],
      everythingFile ? "./Everything.agda",
      includePaths ? [ ],
      libraryName ? pname,
      libraryFile ? "${libraryName}.agda-lib",
      buildPhase ? null,
      installPhase ? null,
      extraExtensions ? [ ],
      ...
    }:
    let
      agdaWithArgs = withPackages (filter (p: p ? isAgdaDerivation) buildInputs);
      includePathArgs = concatMapStrings (path: "-i" + path + " ") (
        includePaths ++ [ (dirOf everythingFile) ]
      );
    in
    {
      inherit libraryName libraryFile;

      isAgdaDerivation = true;

      buildInputs = buildInputs ++ [ agdaWithArgs ];

      buildPhase =
        if buildPhase != null then
          buildPhase
        else
          ''
            runHook preBuild
            agda ${includePathArgs} ${everythingFile}
            rm ${everythingFile} ${lib.interfaceFile Agda.version everythingFile}
            runHook postBuild
          '';

      installPhase =
        if installPhase != null then
          installPhase
        else
          ''
            runHook preInstall
            mkdir -p $out
            find \( ${
              concatMapStringsSep " -or " (p: "-name '*.${p}'") (extensions ++ extraExtensions)
            } \) -exec cp -p --parents -t "$out" {} +
            runHook postInstall
          '';

      # As documented at https://github.com/NixOS/nixpkgs/issues/172752,
      # we need to set LC_ALL to an UTF-8-supporting locale. However, on
      # darwin, it seems that there is no standard such locale; luckily,
      # the referenced issue doesn't seem to surface on darwin. Hence let's
      # set this only on non-darwin.
      LC_ALL = optionalString (!stdenv.hostPlatform.isDarwin) "C.UTF-8";

      meta = if meta.broken or false then meta // { hydraPlatforms = platforms.none; } else meta;

      # Retrieve all packages from the finished package set that have the current package as a dependency and build them
      passthru.tests = filterAttrs (
        name: pkg: self.lib.isUnbrokenAgdaPackage pkg && elem pname (map (pkg: pkg.pname) pkg.buildInputs)
      ) self;
    };
in
{
  mkDerivation = args: stdenv.mkDerivation (args // defaults args);

  inherit mkLibraryFile withPackages withPackages';
}
