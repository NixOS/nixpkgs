let
  b =
    abort "bad file or whatever";
  a =
    {
      # anonymous module
      imports = [ b ];
    };
in
{
  _file = "a-parent";
  imports = [ a ];
}
