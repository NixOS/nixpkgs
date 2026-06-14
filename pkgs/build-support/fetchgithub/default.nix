{
  lib,
  fetchFromGitProvider,
}:
let
  decorate =
    f:
    lib.makeOverridable (
      lib.setFunctionArgs f (lib.functionArgs fetchFromGitProvider // lib.functionArgs f)
    );
in
decorate (
  {
    githubBase ? "github.com",
    ...
  }@args:
  fetchFromGitProvider (
    removeAttrs args [
      "githubBase"
    ]
    // {
      domain = githubBase;
      functionName = "fetchFromGitHub";
      derivationArgs = {
        inherit githubBase;
      };
    }
  )
)
