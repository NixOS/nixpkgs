{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "systemc";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "accellera-official";
    repo = pname;
    rev = version;
    sha256 = "0sj8wlkp68cjhmkd9c9lvm3lk3sckczpz7w9vby64inc1f9fnf0b";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Undefined reference to the sc_core::sc_api_version_2_3_4_XXX
    # https://github.com/accellera-official/systemc/issues/21
    "-DCMAKE_CXX_STANDARD=17"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "The language for System-level design, modeling and verification";
    homepage = "https://systemc.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      victormignot
      amiloradovsky
    ];
  };
}
