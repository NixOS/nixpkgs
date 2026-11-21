{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "mcmojave-cursors";
  version = "0-unstable-2026-05-05";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "McMojave-cursors";
    rev = "7d0bfc1f91028191cdc220b87fd335a235ee4439";
    sha256 = "sha256-4YqSucpxA7jsuJ9aADjJfKRPgPR89oq2l0T1N28+GV0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/McMojave-cursors
    cp -pr dist/* $out/share/icons/McMojave-cursors/

    runHook postInstall
  '';

  meta = with lib; {
    description = "McMojave GTK cursor theme";
    homepage = "https://github.com/vinceliuice/McMojave-cursors";
    license = licenses.mit;
    maintainers = with maintainers; [ cooukiez ];
  };
}
