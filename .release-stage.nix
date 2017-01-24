let
  fileContents = (import lib/strings.nix).fileContents;
in
{
  stage = "unstable";
  version = fileContents ./.version;
}
