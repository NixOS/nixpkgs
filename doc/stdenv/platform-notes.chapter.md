# Platform Notes {#chap-platform-notes}

## Darwin (macOS) {#sec-darwin}

Some common issues when packaging software for Darwin:

- The Darwin `stdenv` uses clang instead of gcc. When referring to the compiler `$CC` or `cc` will work in both cases. Some builds hardcode gcc/g++ in their build scripts, that can usually be fixed with using something like `makeFlags = [ "CC=cc" ];` or by patching the build scripts.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3";
    # ...
    buildPhase = ''
      $CC -o hello hello.c
    '';
  }
  ```

- On Darwin, libraries are linked using absolute paths, libraries are resolved by their `install_name` at link time. Sometimes packages won’t set this correctly causing the library lookups to fail at runtime. This can be fixed by adding extra linker flags or by running `install_name_tool -id` during the `fixupPhase`.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3";
    # ...
    makeFlags = lib.optional stdenv.hostPlatform.isDarwin "LDFLAGS=-Wl,-install_name,$(out)/lib/libfoo.dylib";
  }
  ```

- Even if the libraries are linked using absolute paths and resolved via their `install_name` correctly, tests can sometimes fail to run binaries. This happens because the `checkPhase` runs before the libraries are installed.

  This can usually be solved by running the tests after the `installPhase` or alternatively by using `DYLD_LIBRARY_PATH`. More information about this variable can be found in the *dyld(1)* manpage.

  ```
  dyld: Library not loaded: /nix/store/7hnmbscpayxzxrixrgxvvlifzlxdsdir-jq-1.5-lib/lib/libjq.1.dylib
  Referenced from: /private/tmp/nix-build-jq-1.5.drv-0/jq-1.5/tests/../jq
  Reason: image not found
  ./tests/jqtest: line 5: 75779 Abort trap: 6
  ```

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3";
    # ...
    doInstallCheck = true;
    installCheckTarget = "check";
  }
  ```

- Some packages assume Xcode is available and use `xcrun` to resolve build tools like `clang`, etc. The Darwin stdenv includes `xcrun`, and it will return the path to any binary available in a build.

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
  The package `xcbuild` can be used to build projects that really depend on Xcode. However, this replacement is not 100% compatible with Xcode and can occasionally cause issues.

  Note: Some packages may hardcode an absolute path to `xcrun`, `xcodebuild`, or `xcode-select`. Those paths should be removed or replaced.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3";
    prePatch = ''
      substituteInPlace Makefile \
        --replace-fail /usr/bin/xcrun xcrun
        # or: --replace-fail /usr/bin/xcrun '${lib.getExe' buildPackages.xcbuild "xcrun"}'
    '';
  }
  ```

- Multiple SDKs are available for use in nixpkgs. Each platform has a default SDK (10.12.2 for x86_64-darwin and 11.3 for aarch64-darwin), which is available as the `apple-sdk` package.

  The SDK provides the necessary headers and text-based stubs to link common frameworks and libraries (such as libSystem, which is effectively Darwin’s libc). Projects will sometimes indicate which SDK to use by the Xcode version. As a rule of thumb, subtract one from the Xcode version to get the available SDK in nixpkgs.

  The `DEVELOPER_DIR` variable in the build environment has the path to the SDK in the build environment. The `SDKROOT` variable there contains a sysroot with the framework, header, and library paths. You can reference an SDK’s sysroot from Nix using the `sdkroot` attribute on the SDK package. Note that it is preferable to use `SDKROOT` because the latter will be resolved to the highest SDK version of any available to your derivation.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3";
    # ...
    env.PACKAGE_SPECIFIC_SDK_VAR = apple-sdk_10_15.sdkroot;
    # or
    buildInputs = [ apple-sdk_10_15 ];
    postPatch = ''
      export PACKAGE_SPECIFIC_SDK_VAR=$SDKROOT
    '';
  }
  ```

  The following is a list of Xcode versions, the SDK version in nixpkgs, and the attribute to use to add it. Generally, only the last SDK release for a major version is packaged (each _x_ in 10._x_ until 10.15 is considered a major version).

  | Xcode version      | SDK version                                       | nixpkgs attribute |
  |--------------------|---------------------------------------------------|-------------------|
  | Varies by platform | 10.12.2 (x86_64-darwin)<br/>11.3 (aarch64-darwin) | `apple-sdk`       |
  | 8.0–8.3.3          | 10.12.2                                           | `apple-sdk_10_12` |
  | 9.0–9.4.1          | 10.13.2                                           | `apple-sdk_10_13` |
  | 10.0–10.3          | 10.14.6                                           | `apple-sdk_10_14` |
  | 11.0–11.7          | 10.15.6                                           | `apple-sdk_10_15` |
  | 12.0–12.5.1        | 11.3                                              | `apple-sdk_11`    |
  | 13.0–13.4.1        | 12.3                                              | `apple-sdk_12`    |
  | 14.0–14.3.1        | 13.3                                              | `apple-sdk_13`    |
  | 15.0–15.4          | 14.4                                              | `apple-sdk_14`    |
  | 16.0               | 15.0                                              | `apple-sdk_15`    |

  To use a non-default SDK, add it to your build inputs.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3";
    # ...
    buildInputs = [ apple-sdk_15 ]; # Uses the 15.0 SDK instead of the default SDK for the platform.
  }
  ```

  If your derivation has multiple SDKs its inputs (e.g., because they have been propagated by its dependencies), it will use the highest SDK version available.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3"; # Upstream specifies that it needs Xcode 12 to build, so use the 11.3 SDK.
    # ...
    buildInputs = [ apple-sdk_11 ];
    nativeBuildInputs = [ swift ]; # Propagates the 13.3 SDK, so the 13.3 SDK package will be used instead of the 11.3 SDK.
  }
  ```

- When a package indicates a minimum supported version, also called the deployment target, you can set it in your derivation using `darwinMinVersionHook`. If you need to set a minimum version higher than the default SDK, you should also add the corresponding SDK to your `buildInputs`.

  The deployment target controls how Darwin handles availability and access to some APIs. In most cases, if a deployment target is newer than the first availability of an API, that API will be linked directly. Otherwise, the API will be weakly linked and checked at runtime.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3"; # Upstream specifies the minimum supported version as 12.5.
    buildInputs = [ (darwinMinVersionHook "12.5") ];
  }
  ```

  If your derivation has multiple versions of this hook in its inputs (e.g., because it has been propagated by one of your dependencies), it will use the highest deployment target available.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3"; # Upstream specifies the minimum supported version as 10.15.
    buildInputs = [ qt6.qtbase (darwinMinVersionHook "10.15") ];
  }
  # Qt 6 specifies a minimum version of 12.0, so the minimum version resolves to 12.0.
  ```


- You should rely on the default SDK when possible. If a package specifies a required SDK version, use that version (e.g., libuv requires 11.0, so it should use `apple-sdk_11`). When a package supports multiple SDKs, determine which SDK package to use based on the following rules of thumb:

  - If a package supports multiple SDK versions, use the lowest supported SDK version by the package (but no lower than the default SDK). That ensures maximal platform compatibility for the package.

  - If a package specifies a range of supported SDK versions _and_ a minimum supported version, assume the package is using availability checks to support the indicated minimum version. Add the highest supported SDK and a `darwinMinVersionHook` set to the minimum version supported by the upstream package.

  Warning: Avoid using newer SDKs than an upstream package supports. When a binary is linked on Darwin, the SDK version used to build it is recorded in the binary. Runtime behavior can vary based on the SDK version, which may work fine but can also result in unexpected behavior or crashes when building with an unsupported SDK.

  ```nix
  stdenv.mkDerivation {
    name = "foo-1.2.3";
    # ...
    buildInputs = [ apple-sdk_15 (darwinMinVersionHook "10.15") ]; # Upstream builds with the 15.0 SDK but supports 10.15.
  }
  ```

- Libraries that require a minimum version can propagate an appropriate SDK and `darwinMinVersionHook`. Derivations using that library will automatically use an appropriate SDK and minimum version. Even if the library builds with a newer SDK, it should propagate the minimum supported SDK. Derivations that need a newer SDK can add it to their `buildInputs`.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3";
    # ...
    buildInputs = [ apple-sdk_15 ]; # Upstream builds with the 15.0 SDK but supports 10.15.
    propagatedBuildInputs = [ apple-sdk_10_15 (darwinMinVersionHook "10.15") ];
  }
  # ...
  stdenv.mkDerivation {
    name = "bar-1.2.3";
    # ...
    buildInputs = [ libfoo ]; # Builds with the 10.15 SDK
  }
  # ...
  stdenv.mkDerivation {
    name = "baz-1.2.3";
    # ...
    buildInputs = [ apple-sdk_12 libfoo ]; # Builds with the 12.3 SDK
  }
  ```

- Many SDK libraries and frameworks use text-based stubs to link against system libraries and frameworks, but several are built from source (typically corresponding to the source releases for the latest release of macOS). Several of these are propagated to your package automatically. They can be accessed via the `darwin` package set along with others that are not propagated by default.

  - libiconv
  - libresolv
  - libsbuf

  Other common libraries are available in Darwin-specific versions with modifications from Apple. Note that these packages may be made the default on Darwin in the future.

  - ICU (compatible with the top-level icu package, but it also provides `libicucore.B.dylib` with an ABI compatible with the Darwin system version)
  - libpcap (compatible with the top-level libpcap, but it includes Darwin-specific extensions)

- The legacy SDKs packages are still available in the `darwin` package set under their existing names, but all packages in these SDKs (frameworks, libraries, etc) are stub packages for evaluation compatibility.

  In most cases, a derivation can be updated by deleting all of its SDK inputs (frameworks, libraries, etc). If you had to override the SDK, see below for how to do that using the new SDK pattern. If your derivation depends on the layout of the old frameworks or other internal details, you have more work to do.

  When a package depended on the location of frameworks, references to those framework packages can usually be replaced with `${apple-sdk.sdkroot}/System` or `$SDKROOT/System`. For example, if you substituted `${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks/OpenGL.framework` in your derivation, you should replace it with `${apple-sdk.sdkroot}/System/Library/Frameworks/OpenGL.framework` or `$SDKROOT/System/Library/Frameworks`. The latter is preferred because it supports using the SDK that is resolved when multiple SDKs are propagated (see above).

  Note: the new SDK pattern uses the name `apple-sdk` to better align with nixpkgs naming conventions. The old SDK pattern uses `apple_sdk`.

- There are two legacy patterns that are being phased out. These patterns were used in the past to change the SDK version. They have been reimplemented to use the `apple-sdk` packages.

  - `pkgs.darwin.apple_sdk_11_0.callPackage` - this pattern was used to provide frameworks from the 11.0 SDK. It now adds the `apple-sdk_11` package to your derivation’s build inputs.
  - `overrideSDK` - this stdenv adapter would try to replace the frameworks used by your derivation and its transitive dependencies.  It now adds the `apple-sdk_11` package for `11.0` or the `apple-sdk_12` package for `12.3`. If `darwinMinVersion` is specified, it will add `darwinMinVersionHook` with the specified minimum version. No other SDK versions are supported.

- Darwin supports cross-compilation between Darwin platforms. Cross-compilation from Linux is not currently supported but may be supported in the future. To cross-compile to Darwin, you can set `crossSystem` or use one of the Darwin systems in `pkgsCross`. The `darwinMinVersionHook` and the SDKs support cross-compilation. If you need to specify a different SDK version for a `depsBuildBuild` compiler, add it to your `nativeBuildInputs`.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3";
    # ...
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    nativeBuildInputs = [ apple-sdk_12 ];
    buildInputs = [ apple-sdk_13 ];
    depsTargetTargetPropagated = [ apple-sdk_14 ];
  }
  # The build-build clang will use the 12.3 SDK while the package build itself will use the 13.3 SDK.
  # Derivations that add this package as an input will have the 14.4 SDK propagated to them.
  ```

  The different target SDK and hooks are mangled based on role:

  - `DEVELOPER_DIR_FOR_BUILD` and `MACOSX_DEPLOYMENT_TARGET_FOR_BUILD` for the build platform;
  - `DEVELOPER_DIR` and `MACOSX_DEPLOYMENT_TARGET` for the host platform; and
  - `DEVELOPER_DIR_FOR_TARGET` and `MACOSX_DEPLOYMENT_TARGET_FOR_TARGET` for the build platform.

  In static compilation situations, it is possible for the build and host platform to be the same platform but have different SDKs with the same version (one dynamic and one static). cc-wrapper takes care of handling this distinction.

- The current default versions of the deployment target (minimum version) and SDK are indicated by Darwin-specific attributes on the platform. Because of the ways that minimum version and SDK can be changed that are not visible to Nix, they should be treated as lower bounds. If you need to parameterize over a specific version, create a function that takes the version as a parameter instead of relying on these attributes.

  - `darwinMinVersion` defaults to 10.12 on x86_64-darwin and 11.0 on aarch64-darwin. It sets the default `MACOSX_DEPLOYMENT_TARGET`.
  - `darwinSdkVersion` defaults to 10.12 on x86-64-darwin and 11.0 on aarch64-darwin. Only the major version determines the SDK version, resulting in the 10.12.2 and 11.3 SDKs being used on these platforms respectively.
