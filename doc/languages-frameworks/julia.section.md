# Julia {#sec-julia}

### Installing Julia Packages {#sssec-installing-julia-packages}

Julia compilers available in Nixpkgs have a passthru attribute called
`withPackages`. This function permits creating a collection of
packages ready for use in Julia as in many other language frameworks.
For example, to make the package `Plots` available to Julia you can
use the following attr

```nix
julia-bin.withPackages (ps: with ps; [ Plots ])
```

The list of Julia packages in Nixpkgs is accessible through the
compiler passthru attribute set `juliaPackages`, for example
`julia-bin.juliaPackages`.

Note that, if you try to add a nixpkgs provided package to a Julia
environment when a newer version is available upstream, the Julia
package manager `Pkg` will prefer the latter. To prevent this you can
put `Pkg` in offline mode either by setting the environment variable
{env}`JULIA_PKG_OFFLINE=true` or running {command}`import Pkg;
Pkg.offline()` in Julia.
