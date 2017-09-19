{ lib }:
{
  mkDoc = x:

    let
      validate = {
        # MUST match doc/default.nix's docbookFromDoc function signature
        description,
        examples ? [],
        type ? false,
        params ? [],
        return ? null
      }: x;
    in validate x;

  mkP = name: type: description:
    { inherit name type description; };

  mkR = type: description:
    { inherit type description; };
}
