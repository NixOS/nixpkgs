{
  fetchFromGitHub,
}:

{
  qmplay2 = let
    self = {
      pname = "qmplay2";
      version = "24.04.07";

      src = fetchFromGitHub {
        owner = "zaps166";
        repo = "QMPlay2";
        rev = self.version;
        hash = "sha256-achnbloKJq4t7xwJ7Qn0bAEGjuLx8wiZK7+BOLYZaN0=";
      };
    };
  in
    self;

  qmvk = {
    pname = "qmvk";
    version = "0-unstable-2024-03-30";

    src = fetchFromGitHub {
      owner = "zaps166";
      repo = "QmVk";
      rev = "50826653f34140afd03ccb7e8032715092b34446";
      hash = "sha256-p2yt0PE5j9+YGOj3T1y/z9N3djbXzxh7h27xHCMnAwo=";
    };
  };
}
