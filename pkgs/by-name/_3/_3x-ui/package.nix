{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
}:
let
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "MHSanaei";
    repo = "3x-ui";
    tag = "v${version}";
    hash = "sha256-RZYerYLOOSlWSULwMF1JnY6S0FImzN5SDX/Y+FJnvvg=";
  };

  frontend = buildNpmPackage {
    pname = "3x-ui-frontend";
    inherit version;

    src = "${src}/frontend";

    npmDepsHash = "sha256-95+XlMIyJHu1OHE+2X+RyvJeKVUGcMvgXIdeFhCiBl0=";

    preBuild = ''
      mkdir -p ../internal/web/
      cp -r ${src}/internal/web/translation ../internal/web/translation
    '';

    installPhase = ''
      cp -r ../internal/web/dist $out/
    '';
  };
in
buildGoModule {
  pname = "3x-ui";
  inherit version src;
  vendorHash = "sha256-WP8WYdVdleBTXYiHc7Kc9/EMzyVp/HKNc7ewzpg2o1M=";

  __structuredAttrs = true;

  preBuild = ''
    cp -r ${frontend} internal/web/dist
  '';

  meta = with lib; {
    description = "Xray panel supporting multi-protocol multi-user";
    homepage = "https://github.com/MHSanaei/3x-ui";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.maxmosk ];
  };
}
