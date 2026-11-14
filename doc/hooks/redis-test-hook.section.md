
# `redisTestHook` {#sec-redisTestHook}

This hook starts a Redis server during `checkPhase`. Example:

```nix
{
  stdenv,
  redis,
  redisTestHook,
}:
stdenv.mkDerivation {

  # ...

  nativeCheckInputs = [ redisTestHook ];
}
```

## Variables {#sec-redisTestHook-variables}

The hook logic will read the following variables and set them to a default value if unset or empty.

Exported variables:

- `REDIS_SOCKET`: UNIX domain socket path

Bash-only variables:

- `redisTestPort`: Port to use by Redis. Defaults to `6379`

Example usage:

```nix
{
  stdenv,
  redis,
  redisTestHook,
}:
stdenv.mkDerivation {

  # ...

  nativeCheckInputs = [ redisTestHook ];

  preCheck = ''
    redisTestPort=6390;
  '';
}
```
