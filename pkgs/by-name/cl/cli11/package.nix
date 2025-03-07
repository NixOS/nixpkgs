{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  catch2,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cli11";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-x3/kBlf5LdzkTO4NYOKanZBfcU4oK+fJw9L7cf88LsY=";
  };

  buildInputs = [ catch2 ];
  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [
    boost
    python3
  ];

  doCheck = true;
  strictDeps = true;

  meta = with lib; {
    description = "Command line parser for C++11";
    homepage = "https://github.com/CLIUtils/CLI11";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };
})
