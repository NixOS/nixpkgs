{ lib }:
{
  mkDoc = x:

    let
      validate = {
        description,
        examples ? [],
        type ? false
      }: x;
    in validate x;
}
