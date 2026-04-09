{
  lib,
  stdenv,
  fetchzip,
  zstd,
  autoPatchelfHook,
  pam,
  sqlite,
}:

let
  hash =
    {
      x86_64-linux = "sha256-Emx87E14sNDXfDD46Fy5jscKBeoVGG6+aGlBvJiTx24=";
      aarch64-linux = "sha256-wPwsROSrNyaFcANDEpLrlg+EUFTwMsHNo7XygL/oxAo=";
    }
    .${stdenv.hostPlatform.system} or (throw "unsupported system");
in
stdenv.mkDerivation {
  pname = "littlesnitch";
  version = "1.0.0.1";

  src = fetchzip {
    url = "https://obdev.at/downloads/littlesnitch-linux/littlesnitch-1.0.0-1-${
      if stdenv.hostPlatform.isx86_64 then "x86_64" else "aarch64"
    }.pkg.tar.zst";
    nativeBuildInputs = [ zstd ];
    stripRoot = false;
    inherit hash;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    stdenv.cc.cc
    pam
    sqlite
  ];
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir "$out"
    mv usr/* "$out"
    substituteInPlace "$out/lib/systemd/system/littlesnitch.service" --replace-fail "/usr/bin" "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "Application firewall";
    homepage = "https://obdev.at/products/littlesnitch-linux/index.html";
    changelog = "https://obdev.at/products/littlesnitch-linux/download.html";
    license = lib.licenses.obdevProprietaryFreeware;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
