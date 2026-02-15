{
  lib,
  stdenv,
  fetchzip,
}:

let
  platformMap = {
    x86_64-linux = "rustfetch-x86_64-unknown-linux-gnu.tar.gz";
    aarch64-linux = "rustfetch-aarch64-unknown-linux-gnu.tar.gz";
    x86_64-darwin = "rustfetch-x86_64-apple-darwin.tar.gz";
    aarch64-darwin = "rustfetch-aarch64-apple-darwin.tar.gz";
  };

  filename =
    platformMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hashMap = {
    x86_64-linux = "sha256-STjjBXKt34ws3m8y38wwNwwiW2mZSufSFf22rQ9ywX4=";
    aarch64-linux = "sha256-G9v/hdoT2kPKB/AF4gSoSoaO/YLH6hxMxX0v4gohqzU=";
    x86_64-darwin = "sha256-fM4xJv/qcNS1u4W0u2u0ukr4suA3tEsQe0K70xBGeHk=";
    aarch64-darwin = "sha256-xMTHvro2YkciR99oTQElH+43dmbPfyYjK3Bw1SZigns=";
  };

  fileHash =
    hashMap.${stdenv.hostPlatform.system}
      or (throw "No hash defined for system: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation rec {
  pname = "rustfetch";
  version = "0.2.0";

  src = fetchzip {
    url = "https://github.com/lemuray/rustfetch/releases/download/v${version}/${filename}";
    hash = fileHash;
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp rustfetch $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A CLI tool designed to fetch system information in the fastest and safest way possible";
    homepage = "https://github.com/lemuray/rustfetch";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [ LeFaucheur0769 ];
    mainProgram = "rustfetch";
  };
}
