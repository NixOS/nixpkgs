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

  patches = [
    # https://github.com/Olivia5k/doge/pull/66, adds a small doge
    (fetchpatch {
      url = "https://github.com/Olivia5k/doge/commit/14e3ccc0a3f1e91862492e20a34d008768a34039.patch";
      hash = "sha256-3F+7F9RuoiVWoN+69T7tM871AXX1IQbHqFxD+S3TjxQ=";
    })
  ];

  meta = {
    homepage = "https://github.com/Olivia5k/doge";
    description = "Wow very terminal doge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [Gonzih quantenzitrone];
    mainProgram = "doge";
  };
}
