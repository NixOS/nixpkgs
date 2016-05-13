{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  name = "terminal-notifier-${version}";

  version = "1.5.0";

  src = fetchzip {
    url = "https://github.com/alloy/terminal-notifier/releases/download/${version}/terminal-notifier-${version}.zip";
    sha256 = "09x7vl0kddivqq3pyrk6sg1f0sv5l7nj0bmblq222zk3b09bgg8p";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/Applications
    mkdir -p $out/bin
    cp -r terminal-notifier.app $out/Applications
    cat >$out/bin/terminal-notifier <<EOF
    cd $out/Applications/terminal-notifier.app
    exec ./Contents/MacOS/terminal-notifier "\$@"
    EOF
    chmod +x $out/bin/terminal-notifier
  '';

  meta = with lib; {
    maintainers = with maintainers; [ cstrahan ];
    platforms   = platforms.darwin;
  };
}
