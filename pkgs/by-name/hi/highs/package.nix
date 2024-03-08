{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "highs";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ERGO-Code";
    repo = "HiGHS";
    rev = "v${version}";
    hash = "sha256-Wa5ivUJk0t58FhZD0zy0zxHHj4/p8e9WcxXwu5zenxI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = with lib; {
    description = "High performance serial and parallel linear solver";
    homepage = "https://www.highs.dev";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ david-r-cox ];
    mainProgram = "highs";
  };
}
