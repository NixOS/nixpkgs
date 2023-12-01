{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
}:
python3Packages.buildPythonPackage rec {
  pname = "doge";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "Olivia5k";
    repo = "doge";
    rev = version;
    hash = "sha256-72nRghD5k0ofrlvV3hEdyrr6uzV4+8At1bOCmRZTxhk=";
  };

  meta = {
    homepage = "https://github.com/Olivia5k/doge";
    description = "Wow very terminal doge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [Gonzih quantenzitrone];
    mainProgram = "doge";
  };
}
