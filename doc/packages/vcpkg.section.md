# VCPKG {#sec-vcpkg}

The `vcpkg-tool` package has a wrapper around the `vcpkg` executable to avoid writing to the nix store.
The wrapper will also be present in `vcpkg`, unless you specify `vcpkg.override { vcpkg-tool = vcpkg-tool-unwrapped; }`

The wrapper has been made in a way so that it will provide default cli arguments but tries not to interfere if the user provides the same arguments.
The arguments also have corresponding environment variables that can be used as an alternative way of overriding these paths.

Run the wrapper with the environment variable `NIX_VCPKG_DEBUG_PRINT_ENVVARS=true` to get a full list of corresponding environment variables.

## Nix specific environment variables {#sec-vcpkg-nix-envvars}

The wrapper also provides some new nix-specific environment variables that let you control some of the wrapper functionality.

- `NIX_VCPKG_WRITABLE_PATH = <path>`

   Set this environment variable to specify the path where `vcpkg` will store buildtime artifacts.
   This will become the base path for all of the other paths.

- `NIX_VCPKG_DEBUG_PRINT_ENVVARS = true | false`

   Set this to `true` for the wrapper to print the corresponding environment variables for the arguments that will be provided to the unwrapped executable.
   The list of variables will be printed right before invoking `vcpkg`.
   This can be useful if you suspect that the wrapper for some reason was unable to prioritize user-provided cli args over its default ones, or for fixing other issues like typos or unexpanded environment variables.
