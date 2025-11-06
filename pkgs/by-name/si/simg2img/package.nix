{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "simg2img";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "anestisb";
    repo = "android-simg2img";
    rev = version;
    hash = "sha256-sNHdSbms35YnENASFEG+VMLJGkV/JAlQUVMquDrePDc=";
  };

  # fix GCC 14 error
  # https://github.com/anestisb/android-simg2img/pull/41
  postPatch = ''
    substituteInPlace backed_block.cpp \
      --replace-fail 'calloc(sizeof(struct backed_block_list), 1));' 'calloc(1, sizeof(struct backed_block_list)));'
    substituteInPlace sparse.cpp \
      --replace-fail 'calloc(sizeof(struct sparse_file), 1));' 'calloc(1, sizeof(struct sparse_file)));'
    substituteInPlace simg2simg.cpp \
      --replace-fail 'calloc(sizeof(struct sparse_file*), files);' 'calloc(files, sizeof(struct sparse_file*));'
  '';

  buildInputs = [ zlib ];

  makeFlags = [
    "PREFIX=$(out)"
    "DEP_CXX:=$(CXX)"
  ];

  meta = with lib; {
    description = "Tool to convert Android sparse images to raw images";
    homepage = "https://github.com/anestisb/android-simg2img";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      dezgeg
      arkivm
    ];
  };
}
