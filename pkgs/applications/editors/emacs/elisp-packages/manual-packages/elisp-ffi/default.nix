{
  lib,
  melpaBuild,
  fetchFromGitHub,
  pkg-config,
  libffi,
  writeText,
}:

let
  rev = "da37c516a0e59bdce63fb2dc006a231dee62a1d9";
in
melpaBuild {
  pname = "elisp-ffi";
  version = "20170518.0";

  commit = rev;

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "elisp-ffi";
    inherit rev;
    sha256 = "sha256-StOezQEnNTjRmjY02ub5FRh59aL6gWfw+qgboz0wF94=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libffi ];

  preBuild = ''
    mv ffi.el elisp-ffi.el
    make
  '';

  recipe = writeText "recipe" ''
    (elisp-ffi :repo "skeeto/elisp-ffi" :fetcher github)
  '';

  meta = {
    description = "Emacs Lisp Foreign Function Interface";
    longDescription = ''
      This library provides an FFI for Emacs Lisp so that Emacs
      programs can invoke functions in native libraries. It works by
      driving a subprocess to do the heavy lifting, passing result
      values on to Emacs.
    '';
    license = lib.licenses.publicDomain;
  };
}
