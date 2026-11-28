{
  lib,
  stdenv,
  fetchzip,
  autoconf,
  automake,
  libtool,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libumem";
  version = "4.1.0";

  src = fetchzip {
    url = "https://codeberg.org/gregburd/libumem/archive/v${finalAttrs.version}.tar.gz";
    hash = "sha256-KJMbA7HNuXhvtgmaMuZSXLf8wqarWHrlUlsSb+FzOLw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  enableParallelBuilding = true;

  # Drop the libtool archives: nixpkgs convention, and nothing consumes them
  # (the pkg-config file is the supported interface).
  postInstall = ''
    rm -f "$out"/lib/*.la
  '';

  # The test suite hangs under the Nix sandbox. It is green when run directly
  # (8/8), so the hang is specific to the sandboxed environment and has not
  # been root-caused upstream; leaving doCheck on would wedge the build.
  doCheck = false;

  meta = {
    description = "Userspace slab memory allocator from Solaris/illumos";
    longDescription = ''
      libumem is the userspace slab allocator first shipped in Solaris 9 and
      now the default allocator on Solaris and illumos, ported to Linux,
      Windows and BSD-family systems. Besides the allocator itself it provides
      debugging facilities for leaks, double frees, buffer overruns and
      use-after-free: an audit trail of allocation stacks, redzone and guard
      page modes selected through the UMEM_DEBUG environment variable, the
      umem(1) runtime introspection tool, and GDB and LLDB command modules.

      It can be used either by linking against it or by preloading
      libumem_malloc.so.
    '';
    homepage = "https://codeberg.org/gregburd/libumem";
    license = lib.licenses.cddl;
    maintainers = with lib.maintainers; [ gburd ];
    platforms = lib.platforms.unix;
  };

  passthru.updateScript = nix-update-script { };
})
