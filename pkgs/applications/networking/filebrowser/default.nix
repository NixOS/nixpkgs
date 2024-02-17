{ buildGoModule, buildNpmPackage, fetchFromGitHub, lib }:

let
  version = "2.28.0";
  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-ubfNGsVClMIq7u0DQVrR4Hdr8NNf76QXqLxnRVJHaCM=";
  };

  frontend = buildNpmPackage rec {
    pname = "filebrowser-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-h2Sqco7NHLnaMNgh9Ykggarv6cS0NrA6M9/2nv2RU28=";

    NODE_OPTIONS = "--openssl-legacy-provider";

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv dist $out

      runHook postInstall
    '';
  };
in
buildGoModule rec {
  pname = "filebrowser";
  inherit version src;

  vendorHash = "sha256-pDQyJ0F6gCkJtUnaoSe+lWpgNbk/2GDGQ67S3G+VudE=";

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
    maintainers = with maintainers; [ nielsegberts ];
    mainProgram = "filebrowser";
  };
}
