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
  dist = stdenv.mkDerivation (finalAttrs: {
    name = "daed-dist";
    pname = "daed-dist";
    version = "0.6.0-unstable-2024-06-16";

    src = fetchFromGitHub {
      owner = "daeuniverse";
      repo = "daed";
      fetchSubmodules = true;
      rev = "32d1af726298ca033209a1a7b16e6b24f8792de3";
      hash = "sha256-t6rPnOjzCM2azfAc7u+KL/Yfw5lNo/m2GcFEGBnZvZE=";
    };
    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) version src pname;
      hash = "sha256-H0VYhK4myqZ5xqwJRJSF2okWN2fUsJUx+RU5fipbM5I=";
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
      mv dist/* $out/
      runHook postInstall
    '';
  });

  dae-ebpf = buildGoModule rec {
    pname = "dae";
    version = "dae-ebpf-0.6.0-unstable-2024-06-16";

    src = fetchFromGitHub {
      owner = "daeuniverse";
      repo = pname;
      rev = "8e9311e0f76da739e51be54905318ca175a4cc53";
      hash = "sha256-B4PLEb0HUHBp+C+c4hlTtXp84FWJk/xVpggW/gufcpk=";
      fetchSubmodules = true;
    };

    vendorHash = "sha256-AtYLxR7Fw3+IOSeuPXlq4vMsnS+7MMaFANZDg0yvCl8=";

    proxyVendor = true;

    nativeBuildInputs = [ clang ];

    buildPhase = ''
      runHook preBuild
      make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector -Wno-unused-command-line-argument" \
      NOSTRIP=y \
      ebpf
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r ./* $out
      runHook postInstall
    '';

    # network required
    doCheck = false;
  };
in
buildGoModule rec {
  name = "daed";
  version = "0.6.0-unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "dae-wing";
    rev = "d832011a0392239ce40e16b08c0fe80bbd1e9ff7";
    hash = "sha256-uijsoHm0RgPUpnDaNG8a599MMiBtbgWtjLGUKeSWIDg=";
  };

  vendorHash = "sha256-zqYYEo33OU+lLNA8sVCm3O4tJoQ8UlRwSrEHYoeqrTc=";
  proxyVendor = true;
  preBuild = ''
    # replace built dae ebpf bindings
    rm -r ./dae-core
    cp -r ${dae-ebpf} ./dae-core

    cp -r ${dist} ./webrender/web

    substituteInPlace Makefile \
      --replace /bin/bash "/bin/sh" \

    chmod -R 777 webrender

    go generate ./...

    find webrender/web -type f -size +4k ! -name "*.gz" ! -name "*.woff" ! -name "*.woff2" -exec sh -c "
        echo '{}';
        gzip -9 -k '{}';
        if [ \$(stat -c %s '{}') -lt \$(stat -c %s '{}.gz') ]; then
            rm '{}.gz';
        else
            rm '{}';
        fi
    " ';'
  '';

  tags = [ "embedallowed" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/daeuniverse/dae-wing/db.AppVersion=${version}"
    "-X github.com/daeuniverse/dae-wing/db.AppName=${name}"
  ];

  excludedPackages = [ "dae-core" ];

  postInstall = ''
    mv $out/bin/dae-wing $out/bin/daed
    rm $out/bin/{input,resolver}
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
