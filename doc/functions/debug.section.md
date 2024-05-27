# Debugging Nix Expressions {#sec-debug}

Nix is a unityped, dynamic language, this means every value can potentially appear anywhere. Since it is also non-strict, evaluation order and what ultimately is evaluated might surprise you. Therefore it is important to be able to debug nix expressions.

In the `lib/debug.nix` file you will find a number of functions that help (pretty-)printing values while evaluation is running. You can even specify how deep these values should be printed recursively, and transform them on the fly. Please consult the docstrings in `lib/debug.nix` for usage information.
