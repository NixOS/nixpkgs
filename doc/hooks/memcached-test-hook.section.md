
# `memcachedTestHook` {#sec-memcachedTestHook}

This hook starts a Memcached server during `checkPhase`. Example:

```nix
{ stdenv, memcachedTestHook }:
stdenv.mkDerivation {

  # ...

  nativeCheckInputs = [ memcachedTestHook ];
}
```

If you use a custom `checkPhase`, remember to add the `runHook` calls:
```nix
{
  checkPhase = ''
    runHook preCheck

    # ... your tests

    runHook postCheck
  '';
}
```

## Variables {#sec-memcachedTestHook-variables}

Bash-only variables:

 - `memcachedTestPort`: Port to use by Memcached. Defaults to `11211`

Example usage:

```nix
{ stdenv, memcachedTestHook }:
stdenv.mkDerivation {

  # ...

  nativeCheckInputs = [ memcachedTestHook ];

  preCheck = ''
    memcachedTestPort=1234;
  '';
}
```
