let
  b =
    { someUnknownArg, ... }: someUnknownArg;
in
{
  _file = "a";
  imports = [ b ];
}
