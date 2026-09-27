{
  stdenv,
  autoPatchelfHook,
  lib,
  fetchzip,
}:
let
  version = "9.2.4";
in
stdenv.mkDerivation {
  pname = "elastic-agent";
  inherit version;
  src = fetchzip {
    url =
      {
        x86_64-linux = "https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-${version}-linux-x86_64.tar.gz";
        aarch64-linux = "https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-${version}-linux-arm64.tar.gz";
      }
      .${stdenv.hostPlatform.system}
        or (throw "elastic-agent: unsupported system ${stdenv.hostPlatform.system}");
    hash =
      {
        x86_64-linux = "sha256-NR+86/mss/Kol1AQX1orNHjI6GouHWg8UkQj4xO65qo=";
        aarch64-linux = "sha256-cN3yEyD/aKp5kvNF2zr1gfSrQo0ZBWuZq3mJftzfgbo=";
      }
      .${stdenv.hostPlatform.system}
        or (throw "elastic-agent: unsupported system ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/elastic-agent $out/bin
    cp -r $src/* $out/share/elastic-agent/
    ln -s $out/share/elastic-agent/elastic-agent $out/bin/elastic-agent

    runHook postInstall
  '';

  meta = {
    description = "Elastic Agent";
    homepage = "https://www.elastic.co/elastic-agent";
    mainProgram = "elastic-agent";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = lib.licenses.elastic20;
    maintainers = [ lib.maintainers.rwyattwalker ];
  };
}
