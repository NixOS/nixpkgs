{ pkgs }:

{
  graphene-hardened = {
    libPath = "${pkgs.graphene-hardened-malloc}/lib/libhardened_malloc.so";
    description = ''
      An allocator designed to mitigate memory corruption attacks, such as
      those caused by use-after-free bugs.
    '';
  };

  jemalloc = {
    libPath = "${pkgs.jemalloc}/lib/libjemalloc.so";
    description = ''
      A general purpose allocator that emphasizes fragmentation avoidance
      and scalable concurrency support.
    '';
  };

  scudo = let
    platformMap = {
      aarch64-linux = "aarch64";
      x86_64-linux  = "x86_64";
    };

    systemPlatform = platformMap.${pkgs.stdenv.hostPlatform.system} or (throw "scudo not supported on ${pkgs.stdenv.hostPlatform.system}");
  in {
    libPath = "${pkgs.llvmPackages_latest.compiler-rt}/lib/linux/libclang_rt.scudo-${systemPlatform}.so";
    description = ''
      A user-mode allocator based on LLVM Sanitizer’s CombinedAllocator,
      which aims at providing additional mitigations against heap based
      vulnerabilities, while maintaining good performance.
    '';
  };

  mimalloc = {
    libPath = "${pkgs.mimalloc}/lib/libmimalloc.so";
    description = ''
      A compact and fast general purpose allocator, which may
      optionally be built with mitigations against various heap
      vulnerabilities.
    '';
  };
}
