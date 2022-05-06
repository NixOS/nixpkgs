{ trivialBuild
, lib
, fetchFromGitHub
}:

trivialBuild {
  pname = "header-file-mode";
  version = "unstable-2022-04-19";

  src = fetchFromGitHub {
    owner = "0x4b";
    repo = "header-file-mode";
    rev = "fdf1930730e1b0c3f82490099a1325805491eff5";
    sha256 = "sha256-FJgRI6RLQk9osh7d+YRfrV5CoGCDx2cZvsjAWlm969c=";
  };

  postUnpack = ''
    sourceRoot="$sourceRoot/lisp"
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
