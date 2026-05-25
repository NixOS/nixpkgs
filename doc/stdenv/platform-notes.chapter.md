# Platform Notes {#chap-platform-notes}

## Darwin (macOS) {#sec-darwin}

The Darwin `stdenv` differs from most other ones in Nixpkgs in a few key ways.
These differences reflect the default assumptions for building software on that platform.
In many cases, you can ignore these differences because the software you are packaging is already written with them in mind.
When you do that, write your derivation as normal. You don’t have to include any Darwin-specific special cases.
The easiest way to know whether your derivation requires special handling for Darwin is to write it as if it doesn’t and see if it works.
If it does, you’re done; skip the rest of this.

- Darwin uses Clang by default instead of GCC. Packages that refer to `$CC` or `cc` should just work in most cases.
  Some packages may hardcode `gcc` or `g++`. You can usually fix that by setting `makeFlags = [ "CC=cc" "CXX=C++" ]`.
  If that does not work, you will have to patch the build scripts yourself to use the correct compiler for Darwin.
- Darwin uses the system libc++ by default to avoid ODR violations and potential compatibility issues from mixing LLVM libc++ with the system libc++.
  While mixing the two usually worked, the two implementations are not guaranteed to be ABI compatible and are considered distinct by upstream.
  See the troubleshooting guide below if you need to use newer C++ library features than those supported by the default deployment target.
- Darwin needs an SDK to build software.
  The SDK provides a default set of frameworks and libraries to build software, most of which are specific to Darwin.
  There are multiple versions of the SDK packages in Nixpkgs, but one is included by default in the `stdenv`.
  Usually, you don’t have to change or pick a different SDK. When in doubt, use the default.
- The SDK used by your build can be found using the `DEVELOPER_DIR` environment variable.
  There are also versions of this variable available when cross-compiling depending on the SDK’s role.
  The `SDKROOT` variable is also set with the path to the SDK’s libraries and frameworks.
  `SDKROOT` is always a sub-folder of `DEVELOPER_DIR`.
- Darwin includes a platform-specific tool called `xcrun` to help builds locate binaries they need.
  A version of `xcrun` is part of the `stdenv` on Darwin.
  If your package invokes `xcrun` via an absolute path (such as `/usr/bin/xcrun`), you will need to patch the build scripts to use `xcrun` instead.

To reiterate: you usually don’t have to worry about this stuff.
Start with writing your derivation as if everything is already set up for you (because in most cases it already is).
If you run into issues or failures, continue reading below for how to deal with the most common issues you may encounter.

### Darwin Issue Troubleshooting {#sec-darwin-troubleshooting}

#### Building a C++ package or library says that certain APIs are unavailable {#sec-darwin-libcxx-versions}

While some newer APIs may be available via headers only, some require using a system libc++ with the required API support.
When that happens, your build will fail because libc++ makes failure to use the correct deployment target an error.
To make the newer API available, increase the deployment target to the required version.
Note that it is possible to use libc++ from LLVM instead of increasing the deployment target, but it is not recommended.
Doing so can cause problems when multiple libc++ implementations are linked into a binary (e.g., from dependencies).

##### Using a newer deployment target {#sec-darwin-libcxx-deployment-targets}

See below for how to use a newer deployment target.
For example, `std::print` depends on features that are only available on macOS 13.3 or newer.
To make them available, set the deployment target to 13.3 using `darwinMinVersionHook`.

#### Package fails to build due to missing API availability checks {#sec-darwin-availability-checks}

This is normally a bug in the package or a misconfigured deployment target.
* If it is using an API from a newer release (e.g., from macOS 26.0 while targeting macOS 14.0), it needs to use an availability check.
  The code should be patched to use [`__builtin_available`](https://clang.llvm.org/docs/LanguageExtensions.html#objective-c-available).
  Note that while the linked documentation is for Objective-C, it is applicable to C and C++ except that you use `__builtin_available` in place of `@available`.
* If the package intends to require the newer platform (i.e., it does not support running on older versions with reduced functionality), use `darwinMinVersionHook` to set the deployment target to the required version.
  See below for how to use a newer deployment target.
* If the package actually handles this through some other mechanism (e.g., MoltenVK relies on the running platform’s MSL version), the error can be suppressed.
  To suppress the error, add `-Wno-error=unguarded-availability` to `env.NIX_CFLAGS_COMPILE`.

#### Package requires a non-default SDK or fails to build due to missing frameworks or symbols {#sec-darwin-troubleshooting-using-sdks}

In some cases, you may have to use a non-default SDK.
This can happen when a package requires APIs that are not present in the default SDK.
For example, Metal Performance Shaders were added in macOS 12.
If the default SDK is 11.3, then a package that requires Metal Performance Shaders will fail to build due to missing frameworks and symbols.

To use a non-default SDK, add it to your derivation’s `buildInputs`.
It is not necessary to override the SDK in the `stdenv` nor is it necessary to override the SDK used by your dependencies.
If your derivation needs a non-default SDK at build time (e.g., for a `depsBuildBuild` compiler), see the cross-compilation documentation for which input you should use.

When determining whether to use a non-default SDK, consider the following:

- Try building your derivation with the default SDK. If it works, you’re done.
- If the package specifies a specific version, use that. See below for how to map Xcode version to SDK version.
- If the package’s documentation indicates it supports optional features on newer SDKs, consider using the SDK that enables those features.
  If you’re not sure, use the default SDK.

Note: It is possible to have multiple, different SDK versions in your inputs.
When that happens, the one with the highest version is always used.

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  # ...
  buildInputs = [ apple-sdk_14 ];
}
```

#### What is a “deployment target” (or minimum version)? {#sec-darwin-troubleshooting-using-deployment-targets}

The “deployment target” refers to the minimum version of macOS that is expected to run an application.
In most cases, the default is fine, and you don’t have to do anything else.
If you’re not sure, don’t do anything, and that will probably be fine.

Some packages require setting a non-default deployment target (or minimum version) to gain access to certain APIs.
You do that using the `darwinMinVersionHook`, which takes the deployment target version as a parameter.
There are primarily two ways to determine the deployment target.

- The upstream documentation will specify a deployment target or minimum version. Use that.
- The build will fail because an API requires a certain version. Use that.
- In all other cases, you probably don’t need to specify a minimum version. The default is usually good enough.

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3"; # Upstream specifies the minimum supported version as 12.5.
  buildInputs = [ (darwinMinVersionHook "12.5") ];
}
```

Note: It is possible to have multiple, different instances of `darwinMinVersionHook` in your inputs.
When that happens, the one with the  highest version is always used.

#### Picking an SDK version {#sec-darwin-troubleshooting-picking-sdk-version}

The following is a list of Xcode versions, the SDK version in Nixpkgs, and the attribute to use to add it.
Check your package’s documentation (platform support or installation instructions) to find which Xcode or SDK version to use.
Generally, only the last SDK release for a major version is packaged.

| Xcode version | SDK version | Nixpkgs attribute            |
|---------------|-------------|------------------------------|
| 15.0–15.4     | 14.4        | `apple-sdk_14` / `apple-sdk` |
| 16.0          | 15.0        | `apple-sdk_15`               |
| 26.0+         | 26.0+       | `apple-sdk_26`, etc          |


#### Darwin Default SDK versions {#sec-darwin-troubleshooting-darwin-defaults}

The current default version of the SDK and deployment target (minimum supported version) are indicated by the Darwin-specific platform attributes `darwinSdkVersion` and `darwinMinVersion`.
Because of the ways that minimum version and SDK can be changed that are not visible to Nix, they should be treated as lower bounds.
If you need to parameterize over a specific version, create a function that takes the version as a parameter instead of relying on these attributes.

On macOS, the `darwinMinVersion` is 14.0, and the `darwinSdkVersion` is 14.4.


#### `xcrun` cannot find a binary {#sec-darwin-troubleshooting-xcrun}

`xcrun` searches `PATH` and the SDK’s toolchain for binaries to run.
If it cannot find a required binary, it will fail. When that happens, add the package for that binary to your derivation’s `nativeBuildInputs` (or `nativeCheckInputs` if the failure is happening when running tests).

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  # ...
  nativeBuildInputs = [ bison ];
  buildCommand = ''
    xcrun bison foo.y # produces foo.tab.c
    # ...
  '';
}
```

#### Package requires `xcodebuild` {#sec-darwin-troubleshooting-xcodebuild}

The xcbuild package provides an `xcodebuild` command for packages that really depend on Xcode.
This replacement is not 100% compatible and may run into some issues, but it is able to build many packages.
To use `xcodebuild`, add `xcbuildHook` to your package’s `nativeBuildInputs`.
It will provide a `buildPhase` for your derivation.
You can use `xcbuildFlags` to specify flags to `xcodebuild` such as the required schema.
If a schema has spaces in its name, you must set `__structuredAttrs` to `true`.
See MoltenVK for an example of setting up xcbuild.

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  xcbuildFlags = [
    "-configuration"
    "Release"
    "-project"
    "libfoo-project.xcodeproj"
    "-scheme"
    "libfoo Package (macOS only)"
  ];
  __structuredAttrs = true;
}
```

##### Fixing absolute paths to `xcodebuild`, `xcrun`, and `PlistBuddy` {#sec-darwin-troubleshooting-xcodebuild-absolute-paths}

Many build systems hardcode the absolute paths to `xcodebuild`, `xcrun`, and `PlistBuddy` as `/usr/bin/xcodebuild`, `/usr/bin/xcrun`, and `/usr/libexec/PlistBuddy` respectively.
These paths will need to be replaced with relative paths and the xcbuild package if `xcodebuild` or `PListBuddy` are used.

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/usr/bin/xcodebuild' 'xcodebuild' \
      --replace-fail '/usr/bin/xcrun' 'xcrun' \
      --replace-fail '/usr/bin/PListBuddy' 'PListBuddy'
  '';
}
```

#### How to use libiconv on Darwin {#sec-darwin-troubleshooting-libiconv}

The libiconv package is included in the SDK by default along with libresolv and libsbuf.
You do not need to do anything to use these packages. They are available automatically.
If your derivation needs the `iconv` binary, add the `libiconv` package to your `nativeBuildInputs` (or `nativeCheckInputs` for tests).

#### Library install name issues {#sec-darwin-troubleshooting-install-name}

Libraries on Darwin are usually linked with absolute paths.
This is determined by something called an “install name”, which is resolved at link time.
Sometimes packages will not set this correctly, causing binaries linking to it not to find their libraries at runtime.
This can be fixed by adding extra linker flags or by using `install_name_tool` to set it in `fixupPhase`.

##### Setting the install name via linker flags {#sec-darwin-troubleshooting-install-name-linker-flags}

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  # ...
  makeFlags = lib.optional stdenv.hostPlatform.isDarwin "LDFLAGS=-Wl,-install_name,$(out)/lib/libfoo.dylib";
}
```

##### Setting the install name using `install_name_tool` {#sec-darwin-troubleshooting-install-name-install_name_tool}

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  # ...
  postFixup = ''
    # `-id <install_name>` takes the install name. The last parameter is the path to the library.
    ${stdenv.cc.targetPrefix}install_name_tool -id "$out/lib/libfoo.dylib" "$out/lib/libfoo.dylib"
  '';
}
```

Even if libraries are linked using absolute paths and resolved via their install name correctly, tests in `checkPhase` can sometimes fail to run binaries because they are linked against libraries that have not yet been installed.
This can usually be solved by running the tests after the `installPhase` or by using `DYLD_LIBRARY_PATH` (see {manpage}`dyld(1)` for more on setting `DYLD_LIBRARY_PATH`).

##### Setting the install name using `fixDarwinDylibNames` hook {#sec-darwin-troubleshooting-install-name-fixDarwinDylibNames}

If your package has numerous dylibs needing fixed, while it is preferable to fix the issue in the package’s build, you can update them all by adding the `fixDarwinDylibNames` hook to your `nativeBuildInputs`.
This hook will scan your package’s outputs for dylibs and correct their install names.
Note that if any binaries in your outputs linked those dylibs, you may need to use `install_name_tool` to replace references to them with the correct paths.

#### Propagating an SDK (advanced, compilers-only) {#sec-darwin-troubleshooting-propagating-sdks}

The SDK is a package, and it can be propagated.
`darwinMinVersionHook` with a version specified can also be propagated.
However, most packages should *not* do this.
The exception is compilers.
When you propagate an SDK, it becomes part of your derivation’s public API, and changing the SDK or removing it can be a breaking change.
That is why propagating it is only recommended for compilers.

When authoring a compiler derivation, propagate the SDK only for the ways you expect users to use your compiler.
Depending on your expected use cases, you may have to do one or all of these.

- Put it in `depsTargetTargetPropagated` when your compiler is expected to be added to `nativeBuildInputs`.
  That will ensure the SDK is effectively part of the target derivation’s `buildInputs`.
- If your compiler uses a hook, put it in the hook’s `depsTargetTargetPropagated` instead.
  The effect should be the same as the above.
- If your package uses the builder pattern, update your builder to add the SDK to the derivation’s `buildInputs`.

If you’re not sure whether to propagate an SDK, don’t.
If your package is a compiler or language, and you’re not sure, ask @NixOS/darwin-maintainers for help deciding.

### Dealing with `darwin.apple_sdk.frameworks` {#sec-darwin-legacy-frameworks}

You may see references to `darwin.apple_sdk.frameworks`.
This is the legacy SDK pattern, and it is being phased out.
All packages in `darwin.apple_sdk`, `darwin.apple_sdk_11_0`, and `darwin.apple_sdk_12_3` have been removed.
If your derivation references them, you should delete those references, as the default SDK should be enough to build your package.

Note: the new SDK pattern uses the name `apple-sdk` to better align with Nixpkgs naming conventions.
The legacy SDK pattern uses `apple_sdk`.
You always know you are using the old SDK pattern if the name is `apple_sdk`.

Some derivations may depend on the location of frameworks in those old packages.
To update your derivation to find them in the new SDK, use `$SDKROOT` instead in `preConfigure`.
For example, if you substitute `${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks/OpenGL.framework` in `postPatch`, replace it with `$SDKROOT/System/Library/Frameworks/OpenGL.framework` in `preConfigure`.

Note that if your derivation is changing a system path (such as `/System/Library/Frameworks/OpenGL.framework`), you may be able to remove the path.
Compilers and binutils targeting Darwin look for system paths in the SDK sysroot.
Some of them (such as Zig or `bindgen` for Rust) depend on it.

#### Updating legacy SDK overrides {#sec-darwin-legacy-frameworks-overrides}

The legacy SDK provided two ways of overriding the default SDK.
They have been removed along with the legacy SDKs.

- `pkgs.darwin.apple_sdk_11_0.callPackage` - this pattern was used to provide frameworks from the macOS 11 SDK.
  It is now the same as `callPackage`.
- `overrideSDK` - this stdenv adapter would try to replace the frameworks used by your derivation and its transitive dependencies.
  It added the `apple-sdk_12` package for `12.3` and did nothing for `11.0`.
  If `darwinMinVersion` is specified, it would add `darwinMinVersionHook` with the specified minimum version.
  No other SDK versions were supported.

### Darwin Cross-Compilation {#sec-darwin-legacy-cross-compilation}

Darwin supports cross-compilation between Darwin platforms.
Cross-compilation from Linux is not currently supported but may be supported in the future.
To cross-compile to Darwin, you can set `crossSystem` or use one of the Darwin systems in `pkgsCross`.
The `darwinMinVersionHook` and the SDKs support cross-compilation.
If you need to specify a different SDK version for a `depsBuildBuild` compiler, add it to your `nativeBuildInputs`.

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  # ...
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ apple-sdk_12 ];
  buildInputs = [ apple-sdk_13 ];
  depsTargetTargetPropagated = [ apple-sdk_14 ];
}
# The build-build `clang` will use the 12.3 SDK while the package build itself will use the 13.3 SDK.
# Derivations that add this package as an input will have the 14.4 SDK propagated to them.
```

The different target SDK and hooks are mangled based on role:

- `DEVELOPER_DIR_FOR_BUILD` and `MACOSX_DEPLOYMENT_TARGET_FOR_BUILD` for the build platform;
- `DEVELOPER_DIR` and `MACOSX_DEPLOYMENT_TARGET` for the host platform; and
- `DEVELOPER_DIR_FOR_TARGET` and `MACOSX_DEPLOYMENT_TARGET_FOR_TARGET` for the build platform.

In static compilation situations, it is possible for the build and host platform to be the same platform but have different SDKs with the same version (one dynamic and one static).
cc-wrapper and bintools-wrapper take care of handling this distinction.
