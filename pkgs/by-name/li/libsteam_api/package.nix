{
  lib,
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  writeScript,
  requireFile,
}:

let
  os = {
    i686-linux = "linux32";
    x86_64-linux = "linux64";
    aarch64-linux = "linuxarm64";
    x86_64-darwin = "osx";
    aarch64-darwin = "osx";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libsteam_api";
  version = "1.64";

  __structuredAttrs = true;
  strictDeps = true;

  src = requireFile rec {
    name = "steamworks_sdk_${lib.replaceString "." "" finalAttrs.version}.zip";
    hashMode = "recursive";
    hash = "sha256-RsUx+qKRxYDPW6BQa1QQQ4kTxpGGxyu62nu68g4VtBU=";
    message = ''
      Unfortunately, we cannot download file ${name} automatically
      because it requires a logged-in Steam account.
      Please go to https://partner.steamgames.com/downloads/list
      to download it yourself, and add it to the Nix store using

        nix-prefetch-url --type sha256 --unpack file:///path/to/${name}

      Alternatively, you may use an unofficial mirror as long as
      the hash matches, such as:

        libsteam_api.overrideAttrs (prevAttrs: {
          src = fetchFromGitHub {
            owner = "UlyssesZh";
            repo = "steamworks-sdk";
            tag = "v''${prevAttrs.version}";
            hash = prevAttrs.src.hash;
          };
        })
    '';
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{include/steam,lib}
    cp -a public/steam/*.h $out/include/steam
    cp -a redistributable_bin/${os.${stdenvNoCC.hostPlatform.system}}/* $out/lib

    runHook postInstall
  '';

  outputs = [
    "out"
    "dev"
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Library for interfacing with the Steamworks API";
    homepage = "https://partner.steamgames.com/doc/sdk";
    license = lib.licenses.unfreeRedistributable // {
      fullName = "Valve Corporation Steamworks SDK Access Agreement";
      shortName = "valveSDKLicense";
      url = "https://partner.steamgames.com/documentation/sdk_access_agreement";
    };
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = builtins.attrNames os;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
