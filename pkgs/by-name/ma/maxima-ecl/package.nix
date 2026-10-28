{
  maxima,
  ecl,
  lisp-compiler ? ecl,
  ...
}@args:

maxima.override (
  {
    inherit lisp-compiler;
  }
  // removeAttrs args [
    "maxima"
    "ecl"
    "lisp-compiler"
  ]
)
