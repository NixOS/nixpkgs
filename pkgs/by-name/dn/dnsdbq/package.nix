{
  curl,
  dnsdbq,
  fetchFromGitHub,
  jansson,
  lib,
  nix-update-script,
  stdenv,
  testers,
}:
stdenv.mkDerivation rec {
  pname = "dnsdbq";
  version = "2.6.7";

  src = fetchFromGitHub {
    owner = "dnsdb";
    repo = "dnsdbq";
    rev = "v${version}";
    hash = "sha256-VeoLgDLly5bDIzvcf6Xb+tqCaQxIzeSpoW3ij+Hq4O8=";
  };

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = dnsdbq;
        command = "dnsdbq -v";
      };
    };
  };

  nativeBuildInputs = [
    curl # curl-config
  ];

  buildInputs = [
    curl
    jansson
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp dnsdbq $out/bin
    mkdir -p $out/man/man1
    cp dnsdbq.man $out/man/man1/dnsdbq.1
    runHook postInstall
  '';

  extraOutputsToInstall = [ "man" ];

  meta = {
    description = "C99 program that accesses passive DNS database systems";
    homepage = "https://github.com/dnsdb/dnsdbq";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "dnsdbq";
    platforms = lib.platforms.all;
  };
}
