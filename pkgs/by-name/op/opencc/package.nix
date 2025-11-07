{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  opencc,
  rapidjson,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "opencc";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "BYVoid";
    repo = "OpenCC";
    rev = "ver.${version}";
    sha256 = "sha256-JBTegQs9ALp4LdKKYMNp9GYEgqR9O8IkX6LqatvaTic=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    opencc # opencc_dict
  ];

  buildInputs = [
    rapidjson
  ];

  # TODO use more system dependencies
  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_RAPIDJSON" true)
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "ver."; };
  };

  meta = with lib; {
    homepage = "https://github.com/BYVoid/OpenCC";
    license = licenses.asl20;
    description = "Project for conversion between Traditional and Simplified Chinese";
    longDescription = ''
      Open Chinese Convert (OpenCC) is an opensource project for conversion between
      Traditional Chinese and Simplified Chinese, supporting character-level conversion,
      phrase-level conversion, variant conversion and regional idioms among Mainland China,
      Taiwan and Hong kong.
    '';
    maintainers = with maintainers; [ sifmelcara ];
    platforms = with platforms; linux ++ darwin;
  };
}
