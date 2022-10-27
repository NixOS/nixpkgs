{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofu";
  version = "unstable-2022-04-01";

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = pname;
    rev = "be0e424eecec3fec19ba3518f8fd1bb07b6908dc";
    sha256 = "sha256-jMOmvCsuRtL9EgPicdNEksVgFepL/JZA53o2wzr8uzQ=";
  };

  vendorSha256 = null;

  subPackages = [ "." ];

  postInstall = ''
    ln -s $out/bin/gofu $out/bin/rtree
    ln -s $out/bin/gofu $out/bin/prettyprompt
  '';

  meta = with lib; {
    description = "Multibinary containing several utilities";
    homepage = "https://github.com/majewsky/gofu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
