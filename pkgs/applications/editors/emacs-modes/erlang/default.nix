{ stdenv, erlang }:

stdenv.mkDerivation {

  name = "erlang-mode-${erlang.version}";

  buildInputs = [ ];

  inherit erlang;

  buildCommand = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp "$erlang/lib/erlang/lib/tools"*/emacs/*.el $out/share/emacs/site-lisp/
  '';

  # emacs highlighting */

  meta = {
    homepage = "http://github.com/erlang/otp";
    description = "Erlang mode for Emacs";
    licence = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ "Samuel Rivas <samuelrivas@gmail.com>" ];
  };
}
