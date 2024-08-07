{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "mailsy";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "BalliAsghar";
    repo = "Mailsy";
    rev = version;
    hash = "sha256-RnOWvu023SOcN83xEEkYFwgDasOmkMwSzJ/QYjvTBDo=";
  };

  npmDepsHash = "sha256-ljmqNmLvRHPdsKyOdDfECBXHTIExM6nPZF45lqV+pDM=";

  npmFlags = ["--legacy-peer-deps"];

  dontNpmBuild = true;

  patches = [./fix-file-lookup.patch];

  meta = with lib; {
    description = "Quickly generate a disposable email straight from terminal";
    mainProgram = "mailsy";
    homepage = "https://fig.io/manual/mailsy";
    license = licenses.mit;
    maintainers = [maintainers._404wolf];
  };
}
