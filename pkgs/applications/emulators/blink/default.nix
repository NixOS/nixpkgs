{ stdenv, fetchFromGitHub, fetchpatch, lib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "blink";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "blink";
    rev = finalAttrs.version;
    hash = "sha256-W7yL7Ut3MRygJhFGr+GIj/CK57MkuDTcenft8IvH7jU=";
  };

  # Drop after next release
  patches = [
    (fetchpatch {
      url = "https://github.com/jart/blink/commit/b31fed832b10d32eadaec885fb20dacbb0eb6986.patch";
      hash = "sha256-DfZxW/H58qXAjkQz31YS4SPMz7152ZzNHK7wHopgnQA=";
    })
  ];

  # Do not include --enable-static and --disable-shared flags during static compilation
  dontAddStaticConfigureFlags = true;

  # Don't add --build and --host flags as they are not supported
  configurePlatforms = lib.optionals stdenv.hostPlatform.isStatic [ ];

  # ./configure script expects --static not standard --enable-static
  configureFlags = lib.optional stdenv.hostPlatform.isStatic "--static";

  # 'make check' requires internet connection
  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Tiniest x86-64-linux emulator";
    longDescription = ''
      blink is a virtual machine that runs x86-64-linux programs on different operating systems and hardware architectures. It's designed to do the same thing as the qemu-x86_64 command, except that
      - blink is much smaller in size than qemu-x86_64
      - blink will run your Linux binaries on any POSIX platform, whereas qemu-x86_64 only supports Linux
      - blink goes 2x faster than qemu-x86_64 on some benchmarks, such as SSE integer / floating point math. Blink is also faster at running ephemeral programs such as compilers
    '';

    homepage = "https://github.com/jart/blink";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.all;
  };
})
