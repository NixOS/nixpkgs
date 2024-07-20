{
  lib,
  melpaBuild,
  fetchFromGitHub,
  pkg-config,
  libffi,
}:

melpaBuild {
  pname = "elisp-ffi";
  version = "1.0.0-unstable-2017-05-18";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "elisp-ffi";
    rev = "da37c516a0e59bdce63fb2dc006a231dee62a1d9";
    hash = "sha256-StOezQEnNTjRmjY02ub5FRh59aL6gWfw+qgboz0wF94=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libffi ];

  preBuild = ''
    mv ffi.el elisp-ffi.el
    make
  '';

  meta = {
    description = "Emacs Lisp Foreign Function Interface";
    longDescription = ''
      This library provides an FFI for Emacs Lisp so that Emacs
      programs can invoke functions in native libraries. It works by
      driving a subprocess to do the heavy lifting, passing result
      values on to Emacs.
    '';
    license = lib.licenses.unlicense;
  };
}
