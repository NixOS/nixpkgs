# The LLVM Toolchain {#chap-toolchains}

LLVM is a target-independent optimizer and code generator and serves as the basis for many compilers such as Haskell's GHC, rustc, Zig, and many others. It forms the base tools for Apple's Darwin platform.

## Using LLVM {#sec-using-llvm}

LLVM has two ways of being used. One is by using it across all of Nixpkgs and the other is to compile and build individual packages.

### Building packages with LLVM {#sec-building-packages-with-llvm}

Nixpkgs supports two methods of compiling the world with LLVM. One is via setting `useLLVM` in `crossSystem` while importing. This is the recommended way when cross compiling as it is more expressive. An example of doing `aarch64-linux` cross compilation from `x86_64-linux` with LLVM on the target is the following:

```nix
import <nixpkgs> {
  localSystem = {
    system = "x86_64-linux";
  };
  crossSystem = {
    useLLVM = true;
    linker = "lld";
  };
}
```

Note that we set `linker` to `lld`. This is because LLVM has its own linker, called "lld". By setting it, we utilize Clang and lld within this new instance of Nixpkgs. There is a shorthand method for building everything with LLVM: `pkgsLLVM`. This is easier to use with `nix-build` (or `nix build`):

```bash
nix-build -A pkgsLLVM.hello
```

This will compile the GNU hello package with LLVM and the lld linker like previously mentioned.

#### Using `clangStdenv` {#sec-building-packages-with-llvm-using-clang-stdenv}

Another simple way is to override the stdenv with `clangStdenv`. This causes a single package to be built with Clang. However, this `stdenv` does not override platform defaults to use compiler-rt, libc++, and libunwind. This is the preferred way to make a single package in Nixpkgs build with Clang. There are cases where just Clang isn't enough. For these situations, there is `libcxxStdenv`, which uses Clang with libc++ and compiler-rt.
