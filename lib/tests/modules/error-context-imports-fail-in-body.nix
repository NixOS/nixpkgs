let
  b =
    { ... }: abort "bad module";
in
{
  _file = "a";
  imports = [ b ];
}
