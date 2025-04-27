{
  lib,
  stdenvNoLibc,
  linuxHeaders,
}:

stdenvNoLibc.mkDerivation (finalAttrs: {
  pname = "nolibc";

  inherit (linuxHeaders) version src;

  # Nolibc depends on these headers
  propagatedBuildInputs = [ linuxHeaders ];

  setSourceRoot = ''
    sourceRoot=$(echo */tools/include/nolibc)
  '';

  makeFlags = [ "ARCH=${stdenvNoLibc.hostPlatform.linuxArch}" ];
  makeTarget = [ "headers" ];

  # The Makefile insists on installing to $(OUTPUT)/sysroot, so we satisfy
  # their wish, use the default of current directory, and copy in installPhase.
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r -t "$out" sysroot/*
    runHook postInstall
  '';

  # {check,installCheck}Phase are disabled if cross, so we use our own phase
  postPhases = [ "nolibcCheckPhase" ];

  # For nolibcCheckPhase
  hardeningDisable = [
    "stackprotector" # Segfaults due to no TLS support
  ];

  nolibcCheckPhase =
    ''
      echo "Doing a compilation test"

      cat > hello-world.c <<END
      #include <stdio.h>

      int main() { puts("Hello, world!"); }
      END

      $CC -Os -o hello-world \
        -nostdlib -nostdinc -static -I "$out/include" \
        hello-world.c \
        ${lib.optionalString stdenvNoLibc.cc.isGNU "-lgcc"}
    ''
    + lib.optionalString (stdenvNoLibc.buildPlatform.canExecute stdenvNoLibc.hostPlatform) ''
      echo "Doing a running test"
      ./hello-world
    '';

  meta = {
    description = "Libc alternative for minimal programs with very limited requirements";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/nolibc/linux-nolibc.git";
    license = lib.licenses.mit; # Actually LGPL-2.1 OR MIT
    maintainers = with lib.maintainers; [ dramforever ];
    platforms = lib.platforms.linux;
  };
})
