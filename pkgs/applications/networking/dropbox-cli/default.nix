{ stdenv, coreutils, fetchurl, python }:

stdenv.mkDerivation {
  name = "dropbox-cli";

  src = fetchurl {
    url = "https://linux.dropbox.com/packages/dropbox.py";
    sha256 = "1x46i0aplah4a2nqglb8byl3c60w7h1cjja62myxj2dpxyv7fydy";
  };

  buildInputs = [ coreutils python ];

  phases = "installPhase fixupPhase";
  
  installPhase = ''
    mkdir -pv $out/bin/
    cp $src $out/bin/dropbox-cli
  '';

  fixupPhase = ''
    substituteInPlace $out/bin/dropbox-cli \
      --replace "/usr/bin/python" ${python}/bin/python \
      --replace "use dropbox help" "use dropbox-cli help"
    
    chmod +x $out/bin/dropbox-cli
  '';
  
  meta = {
    homepage = http://dropbox.com;
    description = "Command line client for the dropbox daemon.";
    license = stdenv.lib.licenses.gpl3;
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = stdenv.lib.platforms.linux;
  };
}

