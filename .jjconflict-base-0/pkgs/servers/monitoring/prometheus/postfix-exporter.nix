{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, nixosTests
, systemd
, withSystemdSupport ? true
}:

buildGoModule rec {
  pname = "postfix_exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "postfix_exporter";
    rev = version;
    sha256 = "sha256-63ze51Qbjm+3CV1OFGFa9cS4ucZ+gMKaJyBF2b//CfM=";
  };

  vendorHash = "sha256-a4Lk4wh4mvXEjLgFksZIVVtbp+zTUyjtLVuk7vuot2k=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = lib.optionals withSystemdSupport [ makeWrapper ];
  buildInputs = lib.optionals withSystemdSupport [ systemd ];
  tags = lib.optionals (!withSystemdSupport) "nosystemd";

  postInstall = lib.optionals withSystemdSupport ''
    wrapProgram $out/bin/postfix_exporter \
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postfix; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for Postfix";
    mainProgram = "postfix_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz globin ];
  };
}
