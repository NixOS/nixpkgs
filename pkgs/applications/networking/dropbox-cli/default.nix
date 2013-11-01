{ stdenv, coreutils, fetchurl, python, dropbox }:

stdenv.mkDerivation {
  # 1.6.0 because it's the only version mentioned in the script
  name = "dropbox-cli-1.6.0";

  src = fetchurl {
    # Note: dropbox doesn't version this file. Annoying.
    url = "https://linux.dropbox.com/packages/dropbox.py";
    sha256 = "0p1pg8bw6mlhqi5k8y3pgs7byg0kfvq57s53sh188lb5sxvlg7yz";
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
      --replace "use dropbox help" "use dropbox-cli help" \
      --replace "~/.dropbox-dist/dropboxd" ${dropbox}/bin/dropbox

    chmod +x $out/bin/dropbox-cli
  '';

  meta = {
    homepage = http://dropbox.com;
    description = "Command line client for the dropbox daemon";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    # NOTE: Dropbox itself only works on linux, so this is ok.
    platforms = stdenv.lib.platforms.linux;
  };
}
