{ lib
, fetchzip
, stdenv
, makeWrapper
}:
let
  specs = {
    aarch64-darwin = {
      arch = "Mac_Arm";
      hash = "sha256-8FeYbXzMDoTVxeAaKe3F4SYRKDz2pirRj3BAF7gtCR8=";
      version = "1169958";
    };
    x86_64-darwin = {
      arch = "Mac";
      hash = "sha256-YVUPCu7+lpKksITsBncif2fqoo08iJ/+dCwnoftHpm8=";
      version = "1171203";
    };
  };
  spec = specs.${stdenv.hostPlatform.system} or {
    arch = "";
    hash = "";
    version = "";
  };
in
stdenv.mkDerivation rec {
  pname = "chromium-bin";
  version = spec.version;
  src = fetchzip {
    url = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/${spec.arch}/${spec.version}/chrome-mac.zip";
    hash = spec.hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/bin" "$out/Applications"
    mv -t "$out/Applications/" "Chromium.app/"
    makeWrapper "$out/Applications/Chromium.app/Contents/MacOS/Chromium" "$out/bin/${pname}"
  '';

  meta = {
    description = "An open source web browser from Google (binary release)";
    downloadPage = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html";
    homepage = "https://www.chromium.org/Home/";
    license = lib.licenses.bsd3;
    platforms = builtins.attrNames specs;
    mainProgram = pname;
    maintainers = with lib.maintainers; [
      lrworth
    ];
    hydraPlatforms = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
