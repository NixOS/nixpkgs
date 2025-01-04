let
  b =
    abort "bad file or whatever";
  a =
    {
      _file = "a";
      imports = [ b ];
    };
in
{
  # This _file will not be reported.
  _file = "not-this-file";
  imports = [ a ];
}
