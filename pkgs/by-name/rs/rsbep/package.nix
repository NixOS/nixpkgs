{
  lib,
  stdenv,
  coreutils,
  gawk,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "rsbep";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ttsiodras";
    repo = "rsbep-backup";
    rev = "v${version}";
    sha256 = "0is4jgil3wdqbvx9h66xcyzbqy84ndyydnnay2g9k81a4mcz4dns";
  };

  postFixup = ''
    cd $out/bin

    # Move internal tool 'rsbep_chopper' to libexec
    libexecDir=$out/libexec/rsbep
    mkdir -p $libexecDir
    mv rsbep_chopper $libexecDir

    # Fix store dependencies in scripts
    path="export PATH=$out/bin:$libexecDir:${
      lib.makeBinPath [
        coreutils
        gawk
      ]
    }"
    sed -i "2i$path" freeze.sh
    sed -i "2i$path" melt.sh

    # Remove unneded binary
    rm poorZFS.py
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    cd $TMP
    echo hello > input
    $out/bin/freeze.sh input > packed
    $out/bin/melt.sh packed > output
    diff -u input output
  '';

  meta = with lib; {
    description = "Create resilient backups with Reed-Solomon error correction and byte-spreading";
    homepage = "https://www.thanassis.space/rsbep.html";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.erikarvstedt ];
  };
}
