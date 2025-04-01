{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "jbofihe";
  version = "0.43";

  src = fetchFromGitHub {
    owner = "lojban";
    repo = "jbofihe";
    rev = "v${version}";
    sha256 = "1xx7x1256sjncyzx656jl6jl546vn8zz0siymqalz6v9yf341p98";
  };

  patches = [
    # fix build with gcc14:
    # https://github.com/lojban/jbofihe/pull/19
    ./fix-gcc14-errors.patch
  ];

  nativeBuildInputs = [
    bison
    flex
    perl
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    (cd tests && ./run *.in)
    runHook postCheck
  '';

  meta = with lib; {
    description = "Parser & analyser for Lojban";
    homepage = "https://github.com/lojban/jbofihe";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ chkno ];
  };
}
