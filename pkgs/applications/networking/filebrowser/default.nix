{
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

let
  frontend = buildNpmPackage rec {
    pname = "filebrowser-frontend";
    version = "2.23.0";

    src = fetchFromGitHub {
      owner = "filebrowser";
      repo = "filebrowser";
      rev = "v${version}";
      hash = "sha256-xhBIJcEtxDdMXSgQtLAV0UWzPtrvKEil0WV76K5ycBc=";
    };

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-acNIMKHc4q7eiFLPBtKZBNweEsrt+//0VR6dqwXHTvA=";

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
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-xhBIJcEtxDdMXSgQtLAV0UWzPtrvKEil0WV76K5ycBc=";
  };

  vendorHash = "sha256-MR0ju2Nomb3j78Z+1YcJY+jPd40MZpuOTuQJM94AM8A=";

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
