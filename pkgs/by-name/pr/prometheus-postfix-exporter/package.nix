{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  systemdLibs,
  withSystemdSupport ? true,
}:

buildGoModule rec {
  pname = "postfix_exporter";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "Hsn723";
    repo = "postfix_exporter";
    tag = "v${version}";
    sha256 = "sha256-yswgmQ7nMXuU9FJAjg+k5d2nwze6i/4qNZSQvrUQJog=";
  };

  vendorHash = "sha256-nQ2QuSMYwnedH8Z7V9umfZYv7NeAI+rzctUWlcZMXV8=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = lib.optionals withSystemdSupport [ makeWrapper ];
  buildInputs = lib.optionals withSystemdSupport [ systemdLibs ];
  tags = lib.optionals (!withSystemdSupport) "nosystemd";

  postInstall = lib.optionals withSystemdSupport ''
    wrapProgram $out/bin/postfix_exporter \
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemdLibs}/lib"
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postfix; };

  meta = {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for Postfix";
    mainProgram = "postfix_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      globin
    ];
  };
}
