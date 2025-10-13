{
  lib,
  buildEnv,
  fetchFromGitHub,
  makeBinaryWrapper,
  onscripter,
  pkg-config,
  xcbuildHook,
}:

let
  inherit (onscripter) stdenv;
in
onscripter.overrideAttrs (
  final: prev: {
    pname = "onscripter-en";
    version = "20110930";

    # The website is not available now. Let's use a Museoa backup
    src = fetchFromGitHub {
      owner = "museoa";
      repo = "onscripter-en";
      rev = final.version;
      hash = "sha256-Lc5ZlH2C4ER02NmQ6icfiqpzVQdVUnOmdywGjjjSYSg=";
    };

    patches = lib.optionals stdenv.isDarwin [
      # Build with newer compilers and SDKs
      ./fix-darwin-build.patch
    ];

    sourceRoot = lib.optionalDrvAttr stdenv.isDarwin "source/macosx";

    nativeBuildInputs =
      prev.nativeBuildInputs
      ++ [ pkg-config ]
      ++ lib.optionals stdenv.isDarwin [
        makeBinaryWrapper
        xcbuildHook
      ];

    preUnpack =
      let
        onscrlib = buildEnv {
          name = "onscrlib";
          paths = final.buildInputs;
          extraOutputsToInstall = [ "dev" ];
          extraPrefix = "/onscrlib";
        };
      in
      lib.optionalString stdenv.isDarwin ''
        ln -s ${onscrlib} onscrlib
      '';

    configureFlags = [
      "--no-werror"
    ]
    ++ lib.optionals (!stdenv.cc.isGNU) [
      "--unsupported-compiler"
    ];

    makefile = "Makefile";

    preBuild = lib.optionalString (!stdenv.isDarwin) ''
      sed -i 's/.dll//g' Makefile
    '';

    installPhase = lib.optionalDrvAttr stdenv.isDarwin ''
      runHook preInstall

      mkdir -p $out/{bin,Applications}
      cp -R Products/Release/ONScripter.app $out/Applications
      makeWrapper $out/Applications/ONScripter.app/Contents/MacOS/ONScripter \
        $out/bin/${lib.escapeShellArg final.meta.mainProgram}

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/museoa/onscripter-en";
      description = "English-focused fork of ONScripter";
      license = lib.licenses.gpl2Plus;
      mainProgram = "onscripter-en";
      maintainers = [ ];
      platforms = lib.platforms.unix;
    };
  }
)
