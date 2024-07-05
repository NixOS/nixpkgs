{ lib
, fetchzip
, stdenv
, makeWrapper
}:
let
  specs = {
    aarch64-darwin = {
      arch = "Mac_Arm";
      sha256 = "sha256-8FeYbXzMDoTVxeAaKe3F4SYRKDz2pirRj3BAF7gtCR8=";
      version = "1169958";
    };
    x86_64-darwin = {
      arch = "Mac";
      sha256 = "sha256-YVUPCu7+lpKksITsBncif2fqoo08iJ/+dCwnoftHpm8=";
      version = "1171203";
    };
  };
  spec = specs.${stdenv.hostPlatform.system} or {
    arch = "";
    sha25 = "";
    version = "";
  };
  appName = "Chromium";
in
stdenv.mkDerivation rec {
  pname = "chromium-bin";
  version = spec.version;
  src = fetchzip {
    url = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/${spec.arch}/${spec.version}/chrome-mac.zip";
    sha256 = spec.sha256;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    appDir="$out/Applications/${appName}.app"
    binDir="$appDir"/Contents/MacOS

    mkdir -p $out/bin
    # expects a .app folder in the source folder
    mkdir $out/Applications
    cp -r ${appName}.app/ $appDir

    # Make application available in bin/
    makeWrapper $binDir/${appName} $out/bin/${pname}
  '';

  meta = {
    description = "An open source web browser from Google";
    license = lib.licenses.bsd3;
    platforms = builtins.attrNames specs;
    mainProgram = appName;
    maintainers = with lib.maintainers; [
      michaelCTS
    ];
    name = pname;
    hydraPlatforms = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
