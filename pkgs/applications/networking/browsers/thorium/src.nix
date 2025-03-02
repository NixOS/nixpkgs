let
  data = builtins.fromJSON (builtins.readFile ./src.json);
in
{
  url = data.url;
  sha256 = data.sha256;
}
