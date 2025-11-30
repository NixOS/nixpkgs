{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "atomicparsley";
  version = "20240608.083822.1ed9031";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "atomicparsley";
    tag = version;
    sha256 = "sha256-VhrOMpGNMkNNYjcfCqlHI8gdApWr1ThtcxDwQ6gyV/g=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall
    install -D AtomicParsley $out/bin/AtomicParsley
    runHook postInstall
  '';

  doCheck = true;

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  # copying files so that we dont need to patch the test.sh
  checkPhase = ''
    (
    cp AtomicParsley ../tests
    cd ../tests
    mkdir tests
    mv *.mp4 tests
    ./test.sh
    )
  '';

  meta = with lib; {
    description = "CLI program for reading, parsing and setting metadata into MPEG-4 files";
    homepage = "https://github.com/wez/atomicparsley";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pjones ];
    mainProgram = "AtomicParsley";
  };
}
