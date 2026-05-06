# autoPatchPkgConfigHook {#auto-patch-pkg-config-hook}

The `autoPatchPkgConfigHook` hook replaces all packages listed in `Requires` and
`Requires.private` fields with absolute paths to their pkg-config files. This
effectively means that dependency resolution by `pkg-config` is moved from the
build phase of the dependent package to the build phase of the dependency which
is important since the dependent package may not be aware of its transitive
dependencies.

You should use this hook if your package produces pkg-config files with
non-empty `Requires` or `Requires.private` fields. To use it simply add it to
the `nativeBuildInputs`.
