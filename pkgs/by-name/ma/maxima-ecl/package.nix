{
  maxima,
  ecl,
  lisp-compiler ? ecl,
}:

maxima.override {
  inherit lisp-compiler;
}
