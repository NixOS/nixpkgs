{ lib, fetchurl, buildGoModule, asciidoctor, ruby
}:

buildGoModule rec {
  pname = "reposurgeon";
  version = "4.26";

  src = fetchurl {
    url = "http://www.catb.org/~esr/reposurgeon/reposurgeon-${version}.tar.xz";
    sha256 = "sha256-FuL5pvIM468hEm6rUBKGW6+WlYv4DPHNnpwpRGzMwlY=";
  };

  vendorSha256 = "sha256-QpgRCnsOOZujE405dCe+PYg/zNkqnrfZFfbBFo7adjY=";

  subPackages = [ "." ];

  nativeBuildInputs = [ asciidoctor ruby ];

  postBuild = ''
    patchShebangs .
    make all HTMLFILES=
  '';

  postInstall = ''
    make install prefix=$out HTMLFILES=
  '';

  meta = {
    description = "A tool for editing version-control repository history";
    license = lib.licenses.bsd3;
    homepage = "http://www.catb.org/esr/reposurgeon/";
    maintainers = with lib.maintainers; [ dfoxfranke ];
    platforms = lib.platforms.all;
  };
}
