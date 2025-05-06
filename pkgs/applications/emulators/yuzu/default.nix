{
  callPackage,
  fetchFromGitLab,
  fetchpatch,
  fetchgit,
  fmt_11,
}:

rec {
  torzu = callPackage ./generic.nix ({
    forkName = "torzu";
    version = "unstable-2024-02-26";
    source = fetchgit {
      url = "https://git.ynh.ovh/liberodark/torzu.git";
      rev = "eaa9c9e3a46eb5099193b11d620ddfe96b6aec83";
      hash = "sha256-KxLRXM8Y+sIW5L9oYMSeK95HRb30zGRRSfil9DO+utU=";
      fetchSubmodules = true;
    };
  });

  citron-emu = callPackage ./generic.nix ({
    forkName = "citron";
    version = "0.6.1";
    source = fetchFromGitLab {
      domain = "git.citron-emu.org";
      owner = "citron";
      repo = "emu";
      rev = "7edbccbdc9e0558bf5cff4981f54103ca0c5e27e";
      hash = "sha256-/mk/TRyIz5Uy7pqmSxITzh3s3IvqMTMyzU8fM/dZ2Zo=";
      fetchSubmodules = true;
    };
    patches = [
      # Add explicit cast for CRC checksum value
      ./fix-udp-protocol.patch
      (fetchpatch {
          url = "https://git.citron-emu.org/citron/emu/-/commit/21ca0b31191c4af56a78576c502e8382b4c128b4.patch";
          hash = "sha256-DkCGjeNYjCA7RdB+hBRXuHL8Ckjb+IgWbZ13leQZUF0=";
        }
      )
    ];
    cmakeFlagsPrefix = "CITRON";
    udevFileName = "72-citron-input.rules";
    fmt = fmt_11;
  });
}