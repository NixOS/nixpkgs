{ fetchurl, invalidateFetcherByDrvHash, writeTextFile }:

invalidateFetcherByDrvHash fetchurl {
  name = "test";
  url = "file://" + (writeTextFile {
    name = "derivation-with-a-file-with-spaces";
    text = "this is some content";
    destination = "/file with spaces";
  }) + "/file with spaces";
  sha256 = "sha256:1jk4zjmgab4yh5ifzfnz43sapiv5mifjdblasid4z8vm0wqr6f9p";
}
