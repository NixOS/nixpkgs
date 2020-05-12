{ stdenv, fetchurl }:
let
  version = "2.11.0";
in stdenv.mkDerivation {
  pname = "todo.txt-cli";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ginatrapani/todo.txt-cli/releases/download/v${version}/todo.txt_cli-${version}.tar.gz";
    sha256 = "0majx8lcvhh8ji54qi0sxr833wchdss95fjc92byd8g3lfz27rsz";
  };

  installPhase = ''
    install -vd $out/bin
    install -vm 755 todo.sh $out/bin
    install -vd $out/etc/bash_completion.d
    install -vm 644 todo_completion $out/etc/bash_completion.d/todo
    install -vd $out/etc/todo
    install -vm 644 todo.cfg $out/etc/todo/config
  '';

  meta = {
    description = "Simple plaintext todo list manager";
    homepage = "http://todotxt.com";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
