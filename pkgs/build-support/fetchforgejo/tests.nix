{
  testers,
  fetchFromForgejo,
  ...
}:
{
  # Simple tag-based archive fetch.
  simple-tag = testers.invalidateFetcherByDrvHash fetchFromForgejo {
    name = "zig-source";
    domain = "codeberg.org";
    owner = "ziglang";
    repo = "zig";
    tag = "0.14.0";
    hash = "sha256-VyteIp5ZRt6qNcZR68KmM7CvN2GYf8vj5hP+gHLkuVk=";
  };

  # Rev-based archive fetch (0.16.0, the first release made natively on Codeberg).
  simple-rev = testers.invalidateFetcherByDrvHash fetchFromForgejo {
    name = "zig-0.16.0-source";
    domain = "codeberg.org";
    owner = "ziglang";
    repo = "zig";
    rev = "44d9672fed001115e674fd5ddb32747ef43a7af4";
    hash = "sha256-2sTMhaasyrKoBnyH/hQrNCbi0Vh6HekIrpE4XkyQulQ=";
  };

  # Git-based fetch (exercises the fetchgit path).
  fetch-git = testers.invalidateFetcherByDrvHash fetchFromForgejo {
    name = "zig-git-source";
    domain = "codeberg.org";
    owner = "ziglang";
    repo = "zig";
    tag = "0.14.0";
    forceFetchGit = true;
    hash = "sha256-VyteIp5ZRt6qNcZR68KmM7CvN2GYf8vj5hP+gHLkuVk=";
  };
}
