{ trivialBuild
, lib
, fetchFromGitHub
}:

trivialBuild {
  pname = "header-file-mode";
  version = "unstable-2022-05-13";

  src = fetchFromGitHub {
    owner = "aidalgol";
    repo = "header-file-mode";
    rev = "bcfd19a2c70030ebf5fa68e87aca4b3db8fad13e";
    sha256 = "sha256-XMXOU+vWJ/0e0ny4Dz3DxWpdEfSNXGzm03sBke32Dwc=";
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
