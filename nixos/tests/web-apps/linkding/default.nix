{ handleTest }:
{
  defaults = handleTest ./defaults.nix { };
  overrides = handleTest ./overrides.nix { };
}
