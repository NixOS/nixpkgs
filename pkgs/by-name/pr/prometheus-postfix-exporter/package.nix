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
  version = "0.20.4";

  src = fetchFromGitHub {
    owner = "Hsn723";
    repo = "postfix_exporter";
    tag = "v${version}";
    sha256 = "sha256-LCjTw5nL8xP6ODwVJxj4Zg99CiFvqbzjb931fmhtk0M=";
  };

  vendorHash = "sha256-6lqUygsV1pPGKN9SOZIouPVSZWuSOlPhqFbm16HfzGk=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = lib.optionals withSystemdSupport [ makeWrapper ];
  buildInputs = lib.optionals withSystemdSupport [ systemdLibs ];
  tags = lib.optionals (!withSystemdSupport) [ "nosystemd" ];

  postInstall = lib.optionalString withSystemdSupport ''
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
