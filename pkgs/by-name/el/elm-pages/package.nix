{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  elmPackages,
  writeScriptBin,
  stdenv,
}:
let
  # Patching binwrap by NoOp script
  binwrap = writeScriptBin "binwrap" ''
    #! ${stdenv.shell}
    echo "binwrap called: Returning 0"
    return 0
  '';
  binwrap-install = writeScriptBin "binwrap-install" ''
    #! ${stdenv.shell}
    echo "binwrap-install called: Doing nothing"
  '';
in
buildNpmPackage rec {
  pname = "elm-pages";
  version = "2.1.11";

  src = fetchFromGitHub {
    owner = "dillonkearns";
    repo = "elm-pages";
    rev = "v${version}";
    hash = "sha256-HlxllQJ6vBUiIofKLVFz1gLrKXNW8qcPKqPnCMvaDEY=";
  };

  npmDepsHash = "sha256-eWqea0sU4QMP7U32wmJSwkq7NdMGV7v0r8WSK6CawS0=";

  patches = [ ./fix-read-only.patch ];

  dontNpmBuild = true;

  nativeBuildInputs = [
    binwrap
    binwrap-install
  ];

  versionCheckProgramArg = [ "--version" ];

  postFixup = ''
    wrapProgram $out/bin/elm-pages --prefix PATH : ${
      with elmPackages;
      lib.makeBinPath [
        elm
        elm-review
        elm-optimize-level-2
      ]
    }
  '';

  env.CYPRESS_INSTALL_BINARY = "0";

  meta = {
    description = "A statically typed site generator for Elm.";
    homepage = "https://github.com/dillonkearns/elm-pages";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      turbomack
      jali-clarke
    ];
  };
}
