{
  lib,
  stdenv,
  fetchurl,
  xorg,
  libfaketime,
}:

stdenv.mkDerivation rec {
  pname = "clearlyU";
  version = "12-1.9";

  src = fetchurl {
    url = "https://www.math.nmsu.edu/~mleisher/Software/cu/cu${version}.tgz";
    sha256 = "1xn14jbv3m1khy7ydvad9ydkn7yygdbhjy9wm1v000jzjwr3lv21";
  };

  nativeBuildInputs = [
    xorg.fonttosfnt
    xorg.mkfontscale
    libfaketime
  ];

  buildPhase = ''
    # convert bdf fonts to otb
    for i in *.bdf; do
      name=$(basename "$i" .bdf)
      faketime -f "1970-01-01 00:00:01" fonttosfnt -g 2 -m 2 -v -o "$name.otb" "$i"
    done
  '';

  installPhase = ''
    # install otb and bdf fonts
    fontDir="$out/share/fonts"
    install -m 644 -D *.bdf *.otb -t "$fontDir"
    mkfontdir "$fontDir"
  '';

  meta = with lib; {
    description = "Unicode font";
    license = licenses.mit;
    maintainers = [ maintainers.raskin ];
  };
}
