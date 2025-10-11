{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "date";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-ZSjeJKAcT7mPym/4ViDvIR9nFMQEBCSUtPEuMO27Z+I=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/HowardHinnant/date";
    description = "Date and time library based on the C++11/14/17 <chrono> header";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.mit;
  };
})
