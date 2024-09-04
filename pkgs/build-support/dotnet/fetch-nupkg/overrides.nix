{ autoPatchelfHook }:
{
  # e.g.
  # "Package.Id" =
  #   package:
  #   package.overrideAttrs (old: {
  #     buildInputs = old.buildInputs or [ ] ++ [ hello ];
  #   });
}
