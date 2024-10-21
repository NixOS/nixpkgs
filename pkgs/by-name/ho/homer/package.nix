{ stdenvNoCC, lib, buildNpmPackage, fetchFromGitHub, nodejs, pnpm_8 }:
stdenvNoCC.mkDerivation rec {
  pname = "homer";
  version = "24.04.1";

  src = fetchFromGitHub {
    owner = "bastienwirtz";
    repo = "homer";
    rev = "v${version}";
    hash = "sha256-QGBOvP2EAs9tEziksWRT6Pw5dl76MpzSlNFoCjWExgk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_8.configHook
  ];

  pnpmDeps = pnpm_8.fetchDeps {
    inherit pname version src;
    hash = "sha256-Qfvp7Zpd+/nv8ILmeXi79QfV94an9BxH6Xwk/epT26M=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -R ./dist/* $out/lib/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A full static html/js dashboard, based on a simple yaml configuration file";
    license = licenses.asl20;
    maintainers = [ maintainers.huetremy ];
    homepage = "https://github.com/bastienwirtz/homer";
  };
}
