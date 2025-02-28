# sourceGuard {#setup-hook-sourceGuard}

This hook provides the `sourceGuard` bash function.

Using `sourceGuard` to source scripts ensures two things:

- the script is only sourced if it is a build-time dependency (which is to say it has a `hostOffset` of `-1`)
- the script is only sourced once, even if `sourceGuard` is called multiple times
