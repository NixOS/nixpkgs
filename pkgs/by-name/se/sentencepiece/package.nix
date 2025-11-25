{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  gperftools,

  withGPerfTools ? true,
}:

stdenv.mkDerivation rec {
  pname = "sentencepiece";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "sentencepiece";
    tag = "v${version}";
    sha256 = "sha256-q0JgMxoD9PLqr6zKmOdrK2A+9RXVDub6xy7NOapS+vs=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals withGPerfTools [ gperftools ];

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  # https://github.com/google/sentencepiece/issues/754
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '\$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  meta = with lib; {
    homepage = "https://github.com/google/sentencepiece";
    description = "Unsupervised text tokenizer for Neural Network-based text generation";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pashashocky ];
    # sentencepiece 0.2.1 segfaults on darwin when instantiated
    # See https://github.com/NixOS/nixpkgs/issues/466092
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
  };
}
