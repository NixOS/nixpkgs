{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "gofu";
  version = "unstable-2023-04-25";

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = "gofu";
    rev = "f308ca92d1631e579fbfe3b3da13c93709dc18a2";
    hash = "sha256-8c/Z+44gX7diAhXq8sHOqISoGhYdFA7VUYn7eNMCYxY=";
  };

  vendorHash = null;

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
