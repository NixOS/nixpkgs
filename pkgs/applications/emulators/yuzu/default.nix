{
  callPackage,
  fetchFromGitea,
}:

{
  torzu = callPackage ./generic.nix {
    forkName = "torzu";
    version = "unstable-2024-02-26";
    source = fetchFromGitea {
      domain = "git.ynh.ovh";
      owner = "liberodark";
      repo = "torzu";
      rev = "eaa9c9e3a46eb5099193b11d620ddfe96b6aec83";
      hash = "sha256-KxLRXM8Y+sIW5L9oYMSeK95HRb30zGRRSfil9DO+utU=";
      fetchSubmodules = true;
    };
    patches = [
      # Remove coroutines from debugger to fix boost::asio compatibility issues
      ./fix-debugger.patch
      # Add explicit cast for CRC checksum value
      ./fix-udp-protocol.patch
      # Use specific boost::asio includes and update to modern io_context
      ./fix-udp-client.patch
      # Updates suppressed diagnostics
      ./fix-aarch64-linux-build.patch
    ];
    homepage = "http://vub63vv26q6v27xzv2dtcd25xumubshogm67yrpaz2rculqxs7jlfqad.onion/torzu-emu/torzu";
  };
}
