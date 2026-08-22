# `dieHook` {#diehook}

`dieHook` provides the `die` shell function.
`die` prints an error message and a backtrace, then exits the build with status 1.

Use this hook when your package runs custom shell code that should fail with a clear error message.
Add it to `nativeBuildInputs`, the input list for tools used while building the package:

```nix
{
  stdenv,
  dieHook,
}:
stdenv.mkDerivation {
  nativeBuildInputs = [ dieHook ];
}
```

Then call it with the message to display:

```bash
die "something went wrong"
```
