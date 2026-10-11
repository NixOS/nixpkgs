{
  meson,
  testers,
  fetchFromGitHub,
}:
{
  fetch-subprojects = testers.invalidateFetcherByDrvHash meson.fetchSubprojects rec {
    pname = "mesonlsp";
    version = "5.0.4";
    src = fetchFromGitHub {
      owner = "JCWasmx86";
      repo = "mesonlsp";
      tag = "v${version}";
      hash = "sha256-j8J/IREXYwH6KP9KlUTAfLpNN3n7yJSxoh8fqcvQ2P8=";
    };
    hash = "sha256-/pTj6EfMwv1MM87VW8ABNNn0g8LZX/LVlQS/sDyAk+0=";
  };
}
