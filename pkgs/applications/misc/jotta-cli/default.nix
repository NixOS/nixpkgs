{ stdenv, fetchzip }:

let
  arch = "amd64";
in
stdenv.mkDerivation rec {
  pname = "jotta-cli";
  version = "0.7.33634";
  src = fetchzip {
      url = "https://repo.jotta.us/archives/linux/${arch}/jotta-cli-${version}_linux_${arch}.tar.gz";
      sha256 = "0apbdk4fvmn52w9qyh6hvpk3k0sa810jvvndpsbysnlmi7gv5w62";
      stripRoot = false;
    };

  installPhase = ''
    install -D usr/bin/jotta-cli usr/bin/jottad -t $out/bin/
    mkdir -p $out/share/bash-completion/completions
  '';

  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/jotta-cli
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/jottad
    $out/bin/jotta-cli completion > $out/share/bash-completion/completions/jotta-cli.bash
  '';

  meta = with stdenv.lib; {
    description  = "Jottacloud CLI";
    homepage     = "https://www.jottacloud.com/";
    downloadPage = "https://repo.jotta.us/archives/linux/";
    maintainers  = with maintainers; [ evenbrenden ];
    license      = licenses.unfree;
    platforms    = [ "x86_64-linux" ];
  };
}
