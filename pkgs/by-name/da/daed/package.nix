{
  pnpm,
  nodejs,
  stdenv,
  clang,
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

let
  pname = "daed";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "daed";
    rev = "refs/tags/v${version}";
    hash = "sha256-h1j91XIumuzuJnMxgkCjhuXYPLXoDuFFsfmDwmzlTEI=";
    fetchSubmodules = true;
  };

  web = stdenv.mkDerivation {
    inherit pname version src;

    pnpmDeps = pnpm.fetchDeps {
      inherit pname version src;
      hash = "sha256-vqkiZzd5WOeJem0zUyMsJd6/aHHAjlsIQMkNf+SUvHY=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R dist/* $out/
      runHook postInstall
    '';
  };
in
buildGoModule rec {
  inherit pname version src;
  sourceRoot = "${src.name}/wing";

  vendorHash = "sha256-TBR3MmpTdwIwyekU+nrHhzsN31E30+Rqd3FoBL3dl4U=";
  proxyVendor = true;

  nativeBuildInputs = [ clang ];

  hardeningDisable = [ "zerocallusedregs" ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace-fail /bin/bash /bin/sh

    # ${web} does not have write permission
    mkdir dist
    cp -r ${web}/* dist
    chmod -R 755 dist
  '';

  buildPhase = ''
    runHook preBuild

    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector -Wno-unused-command-line-argument" \
      NOSTRIP=y \
      WEB_DIST=dist \
      AppName=${pname} \
      VERSION=${version} \
      OUTPUT=$out/bin/daed \
      bundle

    runHook postBuild
  '';

  meta = {
    description = "Modern dashboard with dae";
    homepage = "https://github.com/daeuniverse/daed";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    platforms = lib.platforms.linux;
    mainProgram = "daed";
  };
}
