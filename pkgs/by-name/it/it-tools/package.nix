{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs,
  pnpm_8,
}:
stdenv.mkDerivation rec {
  pname = "it-tools";
  version = "2024.10.22-7ca5933";

  src = fetchFromGitHub {
    owner = "CorentinTh";
    repo = "it-tools";
    rev = "v${version}";
    hash = "sha256-SQAZv+9tINRH10lewcuv8G2qwfulLOP8sGjX47LxeUk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_8.configHook
  ];

  pnpmDeps = pnpm_8.fetchDeps {
    inherit pname version src;
    hash = "sha256-m1eXBE5rakcq8NGnPC9clAAvNJQrN5RuSQ94zfgGZxw=";
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

  meta = {
    description = "Self-hostable website containing handy tools for developers, with great UX";
    homepage = "https://it-tools.tech/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ akotro ];
  };
}
