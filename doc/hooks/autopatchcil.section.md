# autoPatchcilHook {#setup-hook-autopatchcilhook}

This is a special setup hook which helps in packaging .NET assemblies/programs in that it automatically tries to find missing shared library dependencies of .NET assemblies based on the given `buildInputs` and `nativeBuildInputs`.

As the hook needs information for the host where the package will be run on, there's a required environment variable called `autoPatchcilRuntimeId` which should be filled in with the RID (Runtime Identifier) of the machine where the output will be run on. If you're using `buildDotnetModule`, it will fall back to `dotnetRuntimeIds` (which is set to `lib.singleton (if runtimeId != null then runtimeId else systemToDotnetRid stdenvNoCC.hostPlatform.system)`) for you if not provided.

In certain situations you may want to run the main command (`autoPatchcil`) of the setup hook on a file or a set of directories instead of unconditionally patching all outputs. This can be done by setting the `dontAutoPatchcil` environment variable to a non-empty value.

By default, `autoPatchcil` will fail as soon as any .NET assembly requires a dependency which cannot be resolved via the given build inputs. In some situations you might prefer to just leave missing dependencies unpatched and continue to patch the rest. This can be achieved by setting the `autoPatchcilIgnoreMissingDeps` environment variable to a non-empty value. `autoPatchcilIgnoreMissingDeps` can be set to a list like `autoPatchcilIgnoreMissingDeps = [ "libcuda.so.1" "libcudart.so.1" ];` or to `[ "*" ]` to ignore all missing dependencies.

The `autoPatchcil` command requires the `--rid` command line flag, informing the RID (Runtime Identifier) it should assume the assemblies will be executed on, and also recognizes a `--no-recurse` command line flag, which prevents it from recursing into subdirectories.

::: {.note}
Since, unlike most native binaries, .NET assemblies are compiled once to run on any platform, many assemblies may have PInvoke stubs for libraries that might not be available on the platform that the package will effectively run on. A few examples are assemblies that call native Windows APIs through PInvoke targeting `kernel32`, `gdi32`, `user32`, `shell32` or `ntdll`.

`autoPatchcil` does its best to ignore dependencies from other platforms by checking the requested file extensions, however not all PInvoke stubs provide an extension so in those cases it will be necessary to list those in `autoPatchcilIgnoreMissingDeps` manually.
:::
