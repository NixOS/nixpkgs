{
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

let
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-2w2oDp+gJZIrdh5wkvnMIUKMlMgAmYpmXSpjUiGJ1kM=";
  };

  frontend = buildNpmPackage rec {
    pname = "filebrowser-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-s6NOs0oa/JBWiSr8sz4MvRLRLCUe/yMukDesGh6rtPs=";

    NODE_OPTIONS = "--openssl-legacy-provider";

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv dist $out

      runHook postInstall
    '';
  };
in
buildGoModule {
  pname = "filebrowser";
  inherit version src;

  vendorHash = "sha256-D8Z3Byo2JHIV1JA6TbhPxd9Uo5P9RppkDV6sh7Gaypo=";

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
    maintainers = with maintainers; [
      nielsegberts
      oakenshield
    ];
    mainProgram = "filebrowser";
  };
}
