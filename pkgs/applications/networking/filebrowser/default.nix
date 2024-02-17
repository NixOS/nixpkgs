{ buildGoModule, buildNpmPackage, fetchFromGitHub, lib }:

let
  version = "2.27.0";
  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-3dQUoPd+L1ndluxsH8D48WEmRUFypOqIiFfN2LbAq1U=";
  };

  frontend = buildNpmPackage rec {
    pname = "filebrowser-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-PB2XCXVYqlZWJtlptxyFK1PTiyJI5nq0tjunkRaLf5E=";

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

  vendorHash = "sha256-vgw3LvRwD8sTpDAxFYVVJY6+rlMH5C5qv2U2UO/me1w=";

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
