let
  b =
    { ... }: {
      _file = "b";
      options = { };
      config = { };

      # This will be rejected, because this is not a shorthand module syntax.
      dummyBadAttr = { };
    };
in
{
  _file = "a";
  imports = [ b ];
}
