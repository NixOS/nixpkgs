{ wrapCommand, bash, fetchurl, perlPackages, mutt, lib }:

let
  src = fetchurl {
    url = "http://www.barsnick.net/sw/grepm";
    sha256 = "0ppprhfw06779hz1b10qvq62gsw73shccsav982dyi6xmqb6jqji";
  };
in wrapCommand "grepm" {
  version = "0.6";
  executable = "${bash}/bin/bash";
  makeWrapperArgs = [ "--add-flags ${src}"
                      "--prefix PATH : ${lib.makeBinPath [perlPackages.grepmail mutt]}"];
  meta = with lib; {
    description = "Wrapper for grepmail utilizing mutt";
    homepage = http://www.barsnick.net/sw/grepm.html;
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
