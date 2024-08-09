{
  autoPatchelfHook,
  lib,
  fetchzip,
  stdenv,
}:

let
  releases = {
    x86_64-linux = {
      suffix = "linux-x64.tar.gz";
      hash = "sha256-ggsMj5Epx2i9yGCLm9dbdV7EC49Trd0dO11goE+vwqA=";
    };
    aarch64-linux = {
      suffix = "linux-aarch64.tar.gz";
      hash = "sha256-FqTcDzKs9SAn4rHq8YpjDLjvwlxcZzC6RYYoBQlkg+s=";
    };
  };
  release =
    releases.${stdenv.hostPlatform.system}
      or (throw "objectbox-c is not supported for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "objectbox-c";
  version = "4.0.1";

  src = fetchzip {
    url = "https://github.com/objectbox/objectbox-c/releases/download/v${version}/objectbox-${release.suffix}";
    inherit (release) hash;
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out

    runHook postInstall
  '';

  meta = {
    description = "C and C++ database for objects and structs";
    homepage = "https://github.com/objectbox/objectbox-c";
    changelog = "https://github.com/objectbox/objectbox-c/blob/${version}/CHANGELOG.md";
    # lib is closed-source, and its usage is mediated by asl20
    # https://github.com/objectbox/objectbox-c/issues/6
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames releases;
  };
}
