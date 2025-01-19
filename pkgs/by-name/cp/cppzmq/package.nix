{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zeromq,
}:

stdenv.mkDerivation rec {
  pname = "cppzmq";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "v${version}";
    sha256 = "sha256-HTdaV1cLbwGYuikS9EAVvAOdLmCoWlvVXlpYsUwY5IA=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ zeromq ];

  cmakeFlags = [
    # Tests try to download googletest at compile time; there is no option
    # to use a system one and no simple way to download it beforehand.
    "-DCPPZMQ_BUILD_TESTS=OFF"
  ];

  meta = {
    homepage = "https://github.com/zeromq/cppzmq";
    license = lib.licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = with lib.maintainers; [ abbradar ];
    platforms = lib.platforms.unix;
  };
}
