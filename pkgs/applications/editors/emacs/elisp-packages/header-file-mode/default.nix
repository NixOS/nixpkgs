{ trivialBuild
, lib
, fetchFromGitHub
}:

trivialBuild {
  pname = "header-file-mode";
  version = "unstable-2022-05-25";

  src = fetchFromGitHub {
    owner = "aidalgol";
    repo = "header-file-mode";
    rev = "cf6ce33b436ae9631aece1cd30a459cb0f89d1cd";
    sha256 = "sha256-+TDJubmBc0Hl+2ms58rnOf3hTaQE3ayrIpGWl4j39GQ=";
  };

  postUnpack = ''
    sourceRoot="$sourceRoot/lisp"
  '';

  postBuild = ''
    emacs -L . --batch -l package --eval '(package-generate-autoloads "header-file" ".")'
  '';

  meta = {
    description = ''
      A major mode that, when associated with the .h file extension, will put
      those file into the major mode of their corresponding implementation file.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aidalgol ];
  };
}
