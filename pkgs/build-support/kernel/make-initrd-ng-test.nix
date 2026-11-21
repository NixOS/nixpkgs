{
  runCommandCC,
  makeInitrdNGTool,
}:

runCommandCC "make-initrd-ng-dlopen-alternatives-test" { } ''
  mkdir first second
  echo 'void fixture(void) {}' > library.c
  for name in preferred fallback needed-a needed-b; do
    $CC -shared -nostdlib -fPIC library.c -Wl,-soname,lib$name.so -o first/lib$name.so
  done
  mv first/libpreferred.so second/

  cat > note.c <<'C'
  #define PAYLOAD "[{\"soname\":[\"libpreferred.so\",\"libfallback.so\"]}]"
  __attribute__((section(".note.dlopen"), aligned(4), used))
  static const struct {
      unsigned int namesz, descsz, type;
      char name[4];
      char desc[sizeof(PAYLOAD)];
  } note = {4, sizeof(PAYLOAD), 0x407c0c0a, "FDO", PAYLOAD};
  C
  $CC -shared -nostdlib note.c -o fixture.so \
    -Wl,-rpath,"$PWD/first:$PWD/second" \
    -Wl,--no-as-needed first/libneeded-a.so first/libneeded-b.so
  echo "[{\"source\":\"$PWD/fixture.so\",\"dlopen\":{\"usePriority\":\"recommended\",\"features\":[]}}]" > input.json

  # SONAME preference takes precedence over search-path order.
  mkdir both
  ${makeInitrdNGTool}/bin/make-initrd-ng input.json both 2>both.log
  test ! -s both.log
  test -f "both$PWD/second/libpreferred.so"
  test ! -e "both$PWD/first/libfallback.so"
  test -f "both$PWD/first/libneeded-a.so"
  test -f "both$PWD/first/libneeded-b.so"

  mv second/libpreferred.so preferred.so
  mkdir fallback
  ${makeInitrdNGTool}/bin/make-initrd-ng input.json fallback 2>fallback.log
  test ! -s fallback.log
  test -f "fallback$PWD/first/libfallback.so"

  mv first/libfallback.so fallback.so
  mv preferred.so second/libpreferred.so
  mkdir preferred
  ${makeInitrdNGTool}/bin/make-initrd-ng input.json preferred 2>preferred.log
  test ! -s preferred.log
  test -f "preferred$PWD/second/libpreferred.so"

  touch $out
''
