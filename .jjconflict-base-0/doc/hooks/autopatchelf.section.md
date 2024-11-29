# autoPatchelfHook {#setup-hook-autopatchelfhook}

This is a special setup hook which helps in packaging proprietary software in that it automatically tries to find missing shared library dependencies of ELF files based on the given `buildInputs` and `nativeBuildInputs`.

You can also specify a `runtimeDependencies` variable which lists dependencies to be unconditionally added to rpath of all executables. This is useful for programs that use dlopen 3 to load libraries at runtime.

In certain situations you may want to run the main command (`autoPatchelf`) of the setup hook on a file or a set of directories instead of unconditionally patching all outputs. This can be done by setting the `dontAutoPatchelf` environment variable to a non-empty value.

By default `autoPatchelf` will fail as soon as any ELF file requires a dependency which cannot be resolved via the given build inputs. In some situations you might prefer to just leave missing dependencies unpatched and continue to patch the rest. This can be achieved by setting the `autoPatchelfIgnoreMissingDeps` environment variable to a non-empty value. `autoPatchelfIgnoreMissingDeps` can be set to a list like `autoPatchelfIgnoreMissingDeps = [ "libcuda.so.1" "libcudart.so.1" ];` or to `[ "*" ]` to ignore all missing dependencies.

The `autoPatchelf` command also recognizes a `--no-recurse` command line flag, which prevents it from recursing into subdirectories.
