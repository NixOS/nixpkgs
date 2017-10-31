{ stdenv, fetchgit, electron } :

stdenv.mkDerivation rec {
  name = "nix-tour";

  buildInputs = [ electron ];

  version = "v0.0.1";

  src = fetchgit {
    url = "https://github.com/nixcloud/tour_of_nix";
    rev = "refs/tags/${version}";
    sha256 = "09b1vxli4zv1nhqnj6c0vrrl51gaira94i8l7ww96fixqxjgdwvb";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp -R * $out/share
    chmod 0755 $out/share/ -R
    echo "#!${stdenv.shell}" > $out/bin/nix-tour
    echo "cd $out/share/" >> $out/bin/nix-tour
    echo "${electron}/bin/electron $out/share/electron-main.js" >> $out/bin/nix-tour
    chmod 0755 $out/bin/nix-tour
  '';

  meta = with stdenv.lib; {
    description = "'the tour of nix' from nixcloud.io/tour as offline version";
    homepage = https://nixcloud.io/tour;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ qknight ];
  };

}