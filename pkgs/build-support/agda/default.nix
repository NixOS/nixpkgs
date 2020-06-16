# Builder for Agda packages.

{ stdenv, lib, self, Agda, runCommandNoCC, makeWrapper, writeText, mkShell, ghcWithPackages }:

with lib.strings;

let
  withPackages' = {
    pkgs,
    ghc ? ghcWithPackages (p: with p; [ ieee ])
  }: let
    pkgs' = if builtins.isList pkgs then pkgs else pkgs self;
    library-file = writeText "libraries" ''
      ${(concatMapStringsSep "\n" (p: "${p}/${p.libraryFile}") pkgs')}
    '';
    pname = "agdaWithPackages";
    version = Agda.version;
  in runCommandNoCC "${pname}-${version}" {
    inherit pname version;
    nativeBuildInputs = [ makeWrapper ];
    passthru.unwrapped = Agda;
  } ''
    mkdir -p $out/bin
    makeWrapper ${Agda}/bin/agda $out/bin/agda \
      --add-flags "--with-compiler=${ghc}/bin/ghc" \
      --add-flags "--library-file=${library-file}" \
      --add-flags "--local-interfaces"
    makeWrapper ${Agda}/bin/agda-mode $out/bin/agda-mode
    ''; # Local interfaces has been added for now: See https://github.com/agda/agda/issues/4526

  withPackages = arg: if builtins.isAttrs arg then withPackages' arg else withPackages' { pkgs = arg; };

  extensions = [
    "agda"
    "agda-lib"
    "agdai"
    "lagda"
    "lagda.md"
    "lagda.org"
    "lagda.rst"
    "lagda.tex"
  ];

  defaults =
    { pname
    , buildInputs ? []
    , everythingFile ? "./Everything.agda"
    , libraryName ? pname
    , libraryFile ? "${libraryName}.agda-lib"
    , buildPhase ? null
    , installPhase ? null
    , extraExtensions ? []
    , ...
    }: let
      agdaWithArgs = withPackages (builtins.filter (p: p ? isAgdaDerivation) buildInputs);
    in
      {
        inherit libraryName libraryFile;

        isAgdaDerivation = true;

        buildInputs = buildInputs ++ [ agdaWithArgs ];

        buildPhase = if buildPhase != null then buildPhase else ''
          runHook preBuild
          agda -i ${dirOf everythingFile} ${everythingFile}
          runHook postBuild
        '';

        installPhase = if installPhase != null then installPhase else ''
          runHook preInstall
          mkdir -p $out
          find \( ${concatMapStringsSep " -or " (p: "-name '*.${p}'") (extensions ++ extraExtensions)} \) -exec cp -p --parents -t "$out" {} +
          runHook postInstall
        '';
      };
in
{
  mkDerivation = args: stdenv.mkDerivation (args // defaults args);

  inherit withPackages withPackages';
}
