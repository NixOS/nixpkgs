{
  binutils,
  lib,
  libucontext,
  pkg-config,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  zlib,
  nix-update-script,
}:

let
  # HACK: work around https://github.com/NixOS/nixpkgs/issues/177129
  # Though this is an issue between Clang and GCC,
  # so it may not get fixed anytime soon...
  empty-libgcc_eh = clangStdenv.mkDerivation {
    pname = "empty-libgcc_eh";
    version = "0";
    dontUnpack = true;
    installPhase = ''
      mkdir -p "$out"/lib
      "${binutils}"/bin/ar r "$out"/lib/libgcc_eh.a
    '';
  };
in

# NOTE: This must be `clang` because `gcc` is known to miscompile or ICE while
# compiling `capnproto` coroutines.
#
# See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102051
# See: https://gerrit.lix.systems/c/lix/+/1874
clangStdenv.mkDerivation rec {
  pname = "capnproto";
  version = "1.2.0";

  # release tarballs are missing some ekam rules
  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnproto";
    rev = "v${version}";
    hash = "sha256-aDcn4bLZGq8915/NPPQsN5Jv8FRWd8cAspkG3078psc=";
  };

  patches = [
    # https://github.com/capnproto/capnproto/pull/2377
    ./fix-libucontext.patch
    # https://github.com/capnproto/capnproto/pull/2410
    ./fix-libatomic.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  propagatedBuildInputs = [
    openssl
    zlib
  ]
  ++ lib.optional (clangStdenv.cc.isClang && clangStdenv.hostPlatform.isStatic) empty-libgcc_eh
  # musl doesn't ship getcontext/setcontext unlike basically every other libc
  ++ lib.optional clangStdenv.hostPlatform.isMusl libucontext;

  # FIXME: separate the binaries from the stuff that user systems actually use
  # This runs into a terrible UX issue in Lix and I just don't want to debug it
  # right now for the couple MB of closure size:
  # https://git.lix.systems/lix-project/lix/issues/551
  # outputs = [ "bin" "dev" "out" ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    # merely requires setcontext/getcontext (libc), lix expects fibers to
    # be available, and we want to make sure that the build will fail if
    # it breaks
    (lib.cmakeBool "WITH_FIBERS" true)
    # Take optimization flags from CXXFLAGS rather than cmake injecting them
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "None")
  ];

  env = {
    # Required to build the coroutine library
    CXXFLAGS = "-std=c++20";
  };

  separateDebugInfo = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://capnproto.org/";
    description = "Cap'n Proto cerealization protocol";
    longDescription = ''
      Cap’n Proto is an insanely fast data interchange format and
      capability-based RPC system. Think JSON, except binary. Or think Protocol
      Buffers, except faster.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    teams = [ lib.teams.lix ];
  };
}
