{
  buildGo123Module,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-zLM1fLrucIhzGdTTDu81ZnTIipK+iRnPhgfMiT1P+yg=";
  };

  frontend = buildNpmPackage rec {
    pname = "filebrowser-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-5/yEMWkNPAS8/PkaHlPBGFLiJu7xK2GHYo5dYqHAfCE=";

    NODE_OPTIONS = "--openssl-legacy-provider";

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv dist $out

      runHook postInstall
    '';
  };
in
buildGo123Module {
  pname = "filebrowser";
  inherit version src;

  vendorHash = "sha256-N5aUs8rgTYXeb0qJhPQBCa6lUDkT6lH1bh+1u4bixos=";

  excludedPackages = [ "tools" ];

  preBuild = ''
    cp -r ${frontend}/dist frontend/
  '';

  passthru = {
    inherit frontend;
  };

  meta = with lib; {
    description = "Filebrowser is a web application for managing files and directories";
    homepage = "https://filebrowser.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ oakenshield ];
    mainProgram = "filebrowser";
  };
}
