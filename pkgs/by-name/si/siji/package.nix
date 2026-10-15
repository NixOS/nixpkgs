{
  lib,
  stdenv,
  fetchFromGitHub,
  libfaketime,
  mkfontscale,
  fonttosfnt,
}:

stdenv.mkDerivation {
  pname = "siji";
  version = "2016-05-13";

  src = fetchFromGitHub {
    owner = "stark";
    repo = "siji";
    rev = "3cbb7fe938c33aaadbb657803ea5946e5157d6e2";
    hash = "sha256-7rakugm65Z+0ZMJoyv//1i1wGdivXiy3QKY13i15CJA=";
  };

  nativeBuildInputs = [
    libfaketime
    fonttosfnt
    mkfontscale
  ];

  buildPhase = ''
    # compress pcf fonts
    gzip -n -9 pcf/*

    # convert bdf fonts to otb
    for i in bdf/*; do
        name=$(basename $i .bdf)
        faketime -f "1970-01-01 00:00:01" \
        fonttosfnt -v -o "$name.otb" "$i"
    done
  '';

  postInstall = ''
    install -m 644 -D *.otb pcf/* -t "$out/share/fonts/misc"
    install -m 644 -D bdf/* -t "$bdf/share/fonts/misc"
    mkfontdir "$out/share/fonts/misc"
    mkfontdir "$bdf/share/fonts/misc"
  '';

  outputs = [
    "out"
    "bdf"
  ];

  meta = {
    homepage = "https://github.com/stark/siji";
    description = "Iconic bitmap font based on Stlarch with additional glyphs";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.asymmetric ];
  };
}
