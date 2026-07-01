{ runTest }:
{
  gitlab = runTest ./gitlab.nix;
  gitlab-ee = runTest ./ee.nix;
  gitlab-ee-activation = runTest ./ee-activation.nix;
  runner = runTest ./runner.nix;
}
