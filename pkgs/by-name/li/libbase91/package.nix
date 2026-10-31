{
  lib,
  stdenv,
  rustPlatform,
  base91,
  fixDarwinDylibNames,

  # passthru
  pkg-config,
  runCommandCC,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libbase91";
  __structuredAttrs = true;
  # The same source and vendored crates as the base91 command-line tool:
  # updating base91 updates both.
  inherit (base91) version src cargoDeps;

  cargoRoot = "rust";
  buildAndTestSubdir = "rust/base91-capi";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  postInstall = ''
    # The shared library under its SONAME, and the linker's name for it.
    if [ -e $out/lib/libbase91.so ]; then
      mv $out/lib/libbase91.so $out/lib/libbase91.so.0
      ln -s libbase91.so.0 $out/lib/libbase91.so
    fi
    install -Dm644 rust/base91-capi/include/base91.h -t $dev/include
    mkdir -p $dev/lib/pkgconfig
    substitute rust/base91-capi/base91.pc.in $dev/lib/pkgconfig/base91.pc \
      --subst-var-by prefix $out \
      --subst-var-by includedir $dev/include \
      --subst-var-by libdir $out/lib \
      --subst-var-by version ${finalAttrs.version} \
      --subst-var-by libs_private ${lib.escapeShellArg finalAttrs.libsPrivate}
  '';

  # The system libraries libbase91.a needs (`rustc --print
  # native-static-libs`), for `pkg-config --static`.
  libsPrivate =
    if stdenv.hostPlatform.isDarwin then
      "-lSystem -lc -lm"
    else
      "-lgcc_s -lutil -lrt -lpthread -lm -ldl -lc";

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };

    # Every function, from C, through pkg-config.
    c-api =
      runCommandCC "libbase91-c-api"
        {
          nativeBuildInputs = [ pkg-config ];
          buildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          src=${finalAttrs.src}/rust/base91-capi/tests/c/api.c
          $CC -Wall -Wextra -Werror -std=c99 $src \
            $(pkg-config --cflags --libs base91) -o api
          ./api
          # The static library, with pkg-config's Libs.private.
          static=${lib.getLib finalAttrs.finalPackage}/lib/libbase91.a
          $CC -Wall -Wextra -Werror -std=c99 $src $(pkg-config --cflags base91) \
            $(pkg-config --static --libs base91 | sed "s|-lbase91|$static|") -o api-static
          ./api-static
          touch $out
        '';

    # Henke's basE91 0.6.0 command-line tool, built against this library,
    # writes exactly what the base91 command writes; small buffers (-m)
    # overlap its input and output, as it does.
    henke-compat =
      runCommandCC "libbase91-henke-compat"
        {
          nativeBuildInputs = [
            pkg-config
            base91
          ];
          buildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          cp ${finalAttrs.src}/rust/base91-testkit/reference/basE91-0.6.0/cli.c .
          $CC -O2 cli.c $(pkg-config --cflags --libs base91) -o henke
          data=${finalAttrs.src}/rust/base91/tests/fixtures/bit0.dat
          for args in "" "-w 0" "-w 40" "-m 64" "-m 1K"; do
            ./henke $args $data > henke.b91
            base91 $args $data > base91.b91
            cmp henke.b91 base91.b91
            ./henke -d $args henke.b91 > henke.dat
            cmp henke.dat $data
          done
          touch $out
        '';
  };

  meta = {
    description = "C library for base91 encoding, with Henke's basE91 API and a SIMD variant";
    longDescription = ''
      libbase91 is the C library of base91-rs. It offers Henke's basE91 API,
      binary compatible with his library (a program built against basE91
      0.6.0 runs unchanged with this one), and a one-shot API for both
      formats: Henke's, and a fixed-width variant that SSE4.1, AVX2 and
      NEON encode and decode at several GiB/s.
    '';
    homepage = "https://github.com/douzebis/base91";
    changelog = "https://github.com/douzebis/base91/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    # The library is MIT; its header declares Henke's basE91 API.
    license = with lib.licenses; [
      mit
      bsd3
    ];
    maintainers = with lib.maintainers; [ douzebis ];
    pkgConfigModules = [ "base91" ];
    platforms = lib.platforms.unix;
  };
})
