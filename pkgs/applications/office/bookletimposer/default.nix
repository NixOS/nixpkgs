{ lib
, fetchFromGitLab
, python3
, intltool
, pandoc
, gobject-introspection
, wrapGAppsHook
, gtk3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bookletimposer";
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "git.codecoop.org";
    owner = "kjo";
    repo = "bookletimposer";
    rev = version;
    sha256 = "sha256-AEpvsFBJfyqLucC0l4AN/nA2+aYBR50BEgAcNDJBSqg=";
  };

  patches = [
    ./i18n.patch
    ./configdir.patch
  ];

  nativeBuildInputs = [ intltool pandoc wrapGAppsHook ];

  buildInputs = [ gobject-introspection ];

  propagatedBuildInputs = [
     gtk3
     (python3.withPackages (ps: with ps; [ distutils_extra pypdf2 pygobject3 ]))
  ];

  meta = {
    homepage = "https://kjo.herbesfolles.org/bookletimposer/";
    description = "A utility to achieve some basic imposition on PDF documents, especially designed to work on booklets";
    platforms = lib.platforms.linux;
    license = "GPL-3.0-or-later";
    maintainers = with lib.maintainers; [ afontain ];
  };
}
