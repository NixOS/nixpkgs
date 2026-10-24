# A property does not hide a value of the wrong type.
{ lib, ... }:
{
  value.a.f = lib.mkDefault "not an int";
}
