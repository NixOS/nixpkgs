{
  stdenv,
  weston,
  mesa,
  makeSetupHook,
}:

if stdenv.hostPlatform.isDarwin then
  null
else
  makeSetupHook {
    name = "headlessDisplayCheckHook";
    propagatedBuildInputs = [ weston ];
  } ./headless-display-check-hook.sh
