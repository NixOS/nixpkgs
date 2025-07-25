{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo123Module,
  nodejs_22,
  pnpm_9,

  nixosTests,
}:

let
  version = "2.40.1";

  pnpm = pnpm_9;
  nodejs = nodejs_22;

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-UsY5pJU0eVeYQVi7Wqf4RrBfPLQv78zHi96mTLJJS1o=";
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "filebrowser-frontend";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    pnpmRoot = "frontend";

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      sourceRoot = "${src.name}/frontend";
      hash = "sha256-AwjMQ9LDJ72x5JYdtLF4V3nxJTYiCb8e/RVyK3IwPY4=";
    };

    installPhase = ''
      runHook preInstall

      pnpm install -C frontend --frozen-lockfile
      pnpm run -C frontend build

      mkdir $out
      mv frontend/dist $out

      runHook postInstall
    '';
  });

in
buildGo123Module {
  pname = "filebrowser";
  inherit version src;

  vendorHash = "sha256-FY5rPzWAzkrDaFktTM7VxO/hMk17/x21PL1sKq0zlxg=";

  excludedPackages = [ "tools" ];

  preBuild = ''
    cp -r ${frontend}/dist frontend/
  '';

  ldflags = [
    "-X github.com/filebrowser/filebrowser/v2/version.Version=v${version}"
  ];

  passthru = {
    inherit frontend;
    tests = {
      inherit (nixosTests) filebrowser;
    };
  };

  meta = with lib; {
    description = "Filebrowser is a web application for managing files and directories";
    homepage = "https://filebrowser.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ oakenshield ];
    mainProgram = "filebrowser";
  };
}
