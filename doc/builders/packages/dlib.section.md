# DLib {#dlib}

[DLib](http://dlib.net/) is a modern, C++\-based toolkit which provides several machine learning algorithms.

## Compiling without AVX support {#compiling-without-avx-support}

Especially older CPUs don't support [AVX](https://en.wikipedia.org/wiki/Advanced_Vector_Extensions) (Advanced Vector Extensions) instructions that are used by DLib to optimize their algorithms.

On the affected hardware errors like `Illegal instruction` will occur. In those cases AVX support needs to be disabled:

```nix
self: super: { dlib = super.dlib.override { avxSupport = false; }; }
```
