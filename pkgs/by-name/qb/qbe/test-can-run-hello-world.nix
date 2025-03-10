{
  stdenv,
  writeText,
  qbe,
}:

# The hello world program available at https://c9x.me/compile/
let
  helloWorld = writeText "hello-world.ssa" ''
    function w $add(w %a, w %b) {        # Define a function add
    @start
      %c =w add %a, %b                   # Adds the 2 arguments
      ret %c                             # Return the result
    }
    export function w $main() {          # Main function
    @start
      %r =w call $add(w 1, w 1)          # Call add(1, 1)
      call $printf(l $fmt, w %r, ...)    # Show the result
      ret 0
    }
    data $fmt = { b "One and one make %d!\n", b 0 }
  '';

in
stdenv.mkDerivation {
  name = "qbe-test-can-run-hello-world";
  meta.timeout = 10;
  buildCommand = ''
    ${qbe}/bin/qbe -o asm.s ${helloWorld}
    cc -o out asm.s
    ./out | grep 'One and one make 2!'
    touch $out
  '';
}
