{
  lib,
  fetchurl,
  buildGoModule,
  asciidoctor,
  ruby,
<<<<<<< HEAD
  which,
}:

buildGoModule (finalAttrs: {
  pname = "reposurgeon";
  version = "5.3";

  src = fetchurl {
    url = "http://www.catb.org/~esr/reposurgeon/reposurgeon-${finalAttrs.version}.tar.xz";
    hash = "sha256-XEPpZyBlTfLGtFQSCHND8OrIPB6ml8HDdg0DSvnmWh8=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "./repocutter -q docgen >cuttercommands.inc" 'echo "/* skipped */" >cuttercommands.inc' \
      --replace-fail "./repotool docgen >toolcommands.inc" 'echo "/* skipped */" >toolcommands.inc'
  '';

  vendorHash = "sha256-4bNhAWkO84imCaBzjBxNCOzG2A/z4lhqvu51wF2GVUo=";
=======
}:

buildGoModule rec {
  pname = "reposurgeon";
  version = "4.26";

  src = fetchurl {
    url = "http://www.catb.org/~esr/reposurgeon/reposurgeon-${version}.tar.xz";
    sha256 = "sha256-FuL5pvIM468hEm6rUBKGW6+WlYv4DPHNnpwpRGzMwlY=";
  };

  vendorHash = "sha256-QpgRCnsOOZujE405dCe+PYg/zNkqnrfZFfbBFo7adjY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "." ];

  nativeBuildInputs = [
    asciidoctor
    ruby
<<<<<<< HEAD
    which
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postBuild = ''
    patchShebangs .
    make all HTMLFILES=
  '';

  postInstall = ''
    make install prefix=$out HTMLFILES=
  '';

  meta = {
    description = "Tool for editing version-control repository history";
    license = lib.licenses.bsd3;
    homepage = "http://www.catb.org/esr/reposurgeon/";
    maintainers = with lib.maintainers; [ dfoxfranke ];
    platforms = lib.platforms.all;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
