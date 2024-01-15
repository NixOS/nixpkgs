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
    makeFlags = lib.optional stdenv.isDarwin "LDFLAGS=-Wl,-install_name,$(out)/lib/libfoo.dylib";
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

- Some packages assume xcode is available and use `xcrun` to resolve build tools like `clang`, etc. This causes errors like `xcode-select: error: no developer tools were found at '/Applications/Xcode.app'` while the build doesn’t actually depend on xcode.

  ```nix
  stdenv.mkDerivation {
    name = "libfoo-1.2.3";
    # ...
    prePatch = ''
      substituteInPlace Makefile \
          --replace-fail '/usr/bin/xcrun clang' clang
    '';
  }
  ```

  The package `xcbuild` can be used to build projects that really depend on Xcode. However, this replacement is not 100% compatible with Xcode and can occasionally cause issues.

- x86_64-darwin uses the 10.12 SDK by default, but some software is not compatible with that version of the SDK. In that case,
  the 11.0 SDK used by aarch64-darwin is available for use on x86_64-darwin. To use it, reference `apple_sdk_11_0` instead of
  `apple_sdk` in your derivation and use `pkgs.darwin.apple_sdk_11_0.callPackage` instead of `pkgs.callPackage`. On Linux, this will
  have the same effect as `pkgs.callPackage`, so you can use `pkgs.darwin.apple_sdk_11_0.callPackage` regardless of platform.
