{
  lib,
  cacert,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nodePackages
}:

let
  pname = "autobrr";
  version = "1.36.0";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "autobrr";
    rev = "v${version}";
    hash = "sha256-HQuiREj84nTv9EpKaFKNmCLLmHRko3QR4qoa6ICWwHY=";
  };

  autobrr-web = stdenvNoCC.mkDerivation {
    pname = "${pname}-web";
    inherit src version;

    nativeBuildInputs = [
      nodePackages.pnpm
      cacert
    ];

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      pnpm --dir web install
      pnpm --dir web run build

      mv web/dist $out

      runHook postBuild
    '';

    dontInstall = true;

    outputHashMode = "recursive";
    outputHash = "sha256-IOrW26Nq+9PYWlzUSpPBfkv3jzs5VlfF0JVFaUCDMmw=";
  };
in
buildGoModule rec {
  inherit pname version src;

  vendorHash = "sha256-SkwSKFEZAmjVnaSowIbrdH667vB5WqNrPuRs/Yh6BLc=";

  preBuild = "cp -r ${autobrr-web}/* web/dist";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Modern, easy to use download automation for torrents and usenet";
    license = licenses.gpl2Plus;
    homepage = "https://autobrr.com/";
    maintainers = with maintainers; [ av-gal ];
    mainProgram = "autobrr";
  };
}
