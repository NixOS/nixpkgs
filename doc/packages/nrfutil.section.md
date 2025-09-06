# nrfutil {#sec-nrfutil}

nrfutil can be built with its installables as following:

```nix
(nrfutil.withExtensions [
  "nrfutil-completion"
  "nrfutil-device"
  "nrfutil-trace"
])
```

Keep in mind that all installables might not be available for every supported platform.
