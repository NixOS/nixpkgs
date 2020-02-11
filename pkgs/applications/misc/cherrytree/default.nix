{ lib, fetchurl, pythonPackages, gettext }:

pythonPackages.buildPythonApplication rec {
  pname = "cherrytree";
  version = "0.38.11";

  src = fetchurl {
    url = "https://www.giuspen.com/software/${pname}-${version}.tar.xz";
    sha256 = "1awrrfyawa7d8qaipvikxm1p0961060az2qvmv9wwpl47zcnk1dn";
  };

  nativeBuildInputs = [ gettext ];

  propagatedBuildInputs = with pythonPackages; [ pygtk dbus-python pygtksourceview ];

  patches = [ ./subprocess.patch ];

  doCheck = false;

  meta = with lib; {
    description = "An hierarchical note taking application";
    longDescription = ''
      Cherrytree is an hierarchical note taking application,
      featuring rich text, syntax highlighting and powerful search
      capabilities. It organizes all information in units called
      "nodes", as in a tree, and can be very useful to store any piece
      of information, from tables and links to pictures and even entire
      documents. All those little bits of information you have scattered
      around your hard drive can be conveniently placed into a
      Cherrytree document where you can easily find it.
    '';
    homepage = "http://www.giuspen.com/cherrytree";
    license = licenses.gpl3;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
