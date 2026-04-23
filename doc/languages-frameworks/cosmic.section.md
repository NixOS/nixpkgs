# COSMIC {#sec-language-cosmic}

## Packaging COSMIC applications {#ssec-cosmic-packaging}

COSMIC (Computer Operating System Main Interface Components) is a desktop environment developed by
System76, primarily for the Pop!_OS Linux distribution. Applications in the COSMIC ecosystem are
written in Rust and use libcosmic, which builds on the Iced GUI framework. This section explains
how to properly package and integrate COSMIC applications within Nix.

### libcosmicAppHook {#ssec-cosmic-libcosmic-app-hook}

The `libcosmicAppHook` is a setup hook that helps with this by automatically configuring
and wrapping applications based on libcosmic. It handles many common requirements like:

- Setting up proper linking for libraries that may be dlopen'd by libcosmic/iced apps
- Configuring XDG paths for settings schemas, icons, and other resources
- Managing Vergen environment variables for build-time information
- Setting up Rust linker flags for specific libraries

To use the hook, simply add it to your package's `nativeBuildInputs`:

```nix
{
  lib,
  rustPlatform,
  libcosmicAppHook,
}:
rustPlatform.buildRustPackage {
  # ...
  nativeBuildInputs = [ libcosmicAppHook ];
  # ...
}
```

### Settings fallback {#ssec-cosmic-settings-fallback}

COSMIC applications use libcosmic's UI components, which may need access to theme settings. The
`cosmic-settings` package provides default theme settings as a fallback in its `share` directory.
By default, `libcosmicAppHook` includes this fallback path in `XDG_DATA_DIRS`, ensuring that COSMIC
applications will have access to theme settings even if they aren't available elsewhere in the
system.

This fallback behavior can be disabled by setting `includeSettings = false` when including the hook:

```nix
{
  lib,
  rustPlatform,
  libcosmicAppHook,
}:
let
  # Get build-time version of libcosmicAppHook
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override {
    includeSettings = false;
  };
in
rustPlatform.buildRustPackage {
  # ...
  nativeBuildInputs = [ libcosmicAppHook' ];
  # ...
}
```

Note that `cosmic-settings` is a separate application and not a part of the libcosmic settings
system itself. It's included by default in `libcosmicAppHook` only to provide these fallback theme
settings.

### Icons {#ssec-cosmic-icons}

COSMIC applications can use icons from the COSMIC icon theme. While COSMIC applications can build
and run without these icons, they would be missing visual elements. The `libcosmicAppHook`
automatically includes `cosmic-icons` in the wrapped application's `XDG_DATA_DIRS` as a fallback,
ensuring that the application has access to its required icons even if the system doesn't have the
COSMIC icon theme installed globally.

Unlike the `cosmic-settings` fallback, the `cosmic-icons` fallback cannot be removed or disabled, as
it is essential for COSMIC applications to have access to these icons for proper visual rendering.

### Runtime Libraries {#ssec-cosmic-runtime-libraries}

COSMIC applications built on libcosmic and Iced require several runtime libraries that are dlopen'd
rather than linked directly. The `libcosmicAppHook` ensures that these libraries are correctly
linked by setting appropriate Rust linker flags. The libraries handled include:

- Graphics libraries (EGL, Vulkan)
- Input libraries (xkbcommon)
- Display server protocols (Wayland, X11)

This ensures that the applications will work correctly at runtime, even though they use dynamic
loading for these dependencies.

### Adding custom wrapper arguments {#ssec-cosmic-custom-wrapper-args}

You can pass additional arguments to the wrapper using `libcosmicAppWrapperArgs` in the `preFixup` hook:

```nix
{
  lib,
  rustPlatform,
  libcosmicAppHook,
}:
rustPlatform.buildRustPackage {
  # ...
  preFixup = ''
    libcosmicAppWrapperArgs+=(--set-default ENVIRONMENT_VARIABLE VALUE)
  '';
  # ...
}
```

## Frequently encountered issues {#ssec-cosmic-common-issues}

### Setting up Vergen environment variables {#ssec-cosmic-common-issues-vergen}

Many COSMIC applications use the Vergen Rust crate for build-time information. The `libcosmicAppHook`
automatically sets up the `VERGEN_GIT_COMMIT_DATE` environment variable based on `SOURCE_DATE_EPOCH`
to ensure reproducible builds.

However, some applications may explicitly require additional Vergen environment variables.
Without these properly set, you may encounter build failures with errors like:

```
>   cargo:rerun-if-env-changed=VERGEN_GIT_COMMIT_DATE
>   cargo:rerun-if-env-changed=VERGEN_GIT_SHA
>
>   --- stderr
>   Error: no suitable 'git' command found!
> warning: build failed, waiting for other jobs to finish...
```

While `libcosmicAppHook` handles `VERGEN_GIT_COMMIT_DATE`, you may need to explicitly set other
variables. For applications that require these variables, you should set them directly in the
package definition:

```nix
{
  lib,
  rustPlatform,
  libcosmicAppHook,
}:
rustPlatform.buildRustPackage {
  # ...
  env = {
    VERGEN_GIT_COMMIT_DATE = "2025-01-01";
    VERGEN_GIT_SHA = "0000000000000000000000000000000000000000"; # SHA-1 hash of the commit
  };
  # ...
}
```

Not all COSMIC applications require these variables, but for those that do, setting them explicitly
will prevent build failures.
