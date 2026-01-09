{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  gmp,
  mpfr,
  python3,
  jemalloc,
  ninja,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "lean2";
  version = "2018-10-01";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean2";
    rev = "8072fdf9a0b31abb9d43ab894d7a858639e20ed7";
    sha256 = "12bscgihdgvaq5xi0hqf5r4w386zxm3nkx1n150lv5smhg8ga3gg";
  };

  patches = [
    # https://github.com/leanprover/lean2/pull/13
    (fetchpatch {
      name = "lean2-fix-compilation-error.patch";
      url = "https://github.com/collares/lean2/commit/09b316ce75fd330b3b140d138bcdae2b0e909234.patch";
      sha256 = "060mvqn9y8lsn4l20q9rhamkymzsgh0r1vzkjw78gnj8kjw67jl5";
    })
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.10)"

    # 'class lean::static_matrix<T, X>' has no member named 'get'
    substituteInPlace src/util/lp/static_matrix.h \
      --replace-fail "m_matrix.get(" "m_matrix.get_elem("

    # 'const class lean::static_matrix<T, X>' has no member named 'get_value_of_column_cell'
    substituteInPlace src/util/lp/static_matrix.cpp \
     --replace-fail "A.get_value_of_column_cell(col)" "A[col]"
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
  ];
  buildInputs = [
    gmp
    mpfr
    python3
    jemalloc
  ];

  preConfigure = ''
    patchShebangs bin/leantags
    cd src
  '';

  cmakeFlags = [ "-GNinja" ];

  postInstall = ''
    wrapProgram $out/bin/linja --prefix PATH : $out/bin:${ninja}/bin
  '';

  meta = {
    description = "Automatic and interactive theorem prover (version with HoTT support)";
    homepage = "http://leanprover.github.io";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
    ];
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "lean";
  };
}
