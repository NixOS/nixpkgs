{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liburing";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "liburing";
    tag = "liburing-${finalAttrs.version}";
    hash = "sha256-ZWM+SKeRw5iivyj0mHSxC6yw492N7CThx/pp4FJhkCo=";
  };

  separateDebugInfo = true;
  enableParallelBuilding = true;
  # Upstream's configure script is not autoconf generated, but a hand written one.
  setOutputFlags = false;
  dontDisableStatic = true;
  dontAddStaticConfigureFlags = true;
  configureFlags = [
    "--includedir=${placeholder "dev"}/include"
    "--mandir=${placeholder "man"}/share/man"
  ];

  # mysterious link failure
  hardeningDisable = [ "trivialautovarinit" ];

  # Doesn't recognize platform flags
  configurePlatforms = [ ];

  outputs = [
    "out"
    "bin"
    "dev"
    "man"
  ];

  postInstall = ''
    # Always builds both static and dynamic libraries, so we need to remove the
    # libraries that don't match stdenv type.
    rm $out/lib/liburing*${if stdenv.hostPlatform.isStatic then ".so*" else ".a"}

    # Copy the examples into $bin. Most reverse dependency of
    # this package should reference only the $out output
    for file in $(find ./examples -executable -type f); do
      install -Dm555 -t "$bin/bin" "$file"
    done
  '';

  meta = {
    description = "Userspace library for the Linux io_uring API";
    homepage = "https://github.com/axboe/liburing";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      thoughtpolice
      nickcao
    ];
  };
})
