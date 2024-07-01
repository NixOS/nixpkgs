{
  fetchFromGitHub,
}:

{
  qmplay2 = let
    self = {
      pname = "qmplay2";
      version = "24.06.16";

      src = fetchFromGitHub {
        owner = "zaps166";
        repo = "QMPlay2";
        rev = self.version;
        fetchSubmodules = true;
        hash = "sha256-ECDEyF16GwIKn1raG7J56HFMYk4G6ezwAG2BEy8hUZs=";
      };
    };
  in
    self;
}
