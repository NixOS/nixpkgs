{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "ism7mqtt";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "zivillian";
    repo = "ism7mqtt";
    tag = "v${version}";
    hash = "sha256-hswtuIJqpPCnRNHQ0Uq2NtKY06dERSmc4+nB8BKUjao=";
  };

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  enableParallelBuilding = false;

  meta = {
    homepage = "https://github.com/zivillian/ism7mqtt";
    description = "Get all statistics and values from your Wolf ISM7 and send them to an MQTT server without using the SmartSet cloud.";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kritnich ];
  };
}
