{stdenv, fetchurl, wxGTK, chmlib}:

stdenv.mkDerivation {
  name = "xchm-1.9";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xchm-1.9.tar.gz;
    md5 = "12e1faf49447c743c5c936636cd8a172";
  };
  buildInputs = [wxGTK chmlib];

  meta = {
    description = "A viewer for Microsoft HTML Help files";
  };
}
