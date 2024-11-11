{
  lib,
  stdenvNoCC,
  requireFile,
  libarchive,
}:
stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    sdkName = "idasdk_pro${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}.zip";
  in
  {
    pname = "ida-sdk_8";
    version = "8.4";

    src = requireFile {
      name = sdkName;
      hash = "sha256-NQqrsoFzxceAGYZ6xskJL9TueP1Jn/x54UqTnLnmHiE=";
      message = ''
        Unfortunately, you need to first obtain a copy of the IDA SDK v${finalAttrs.version} from Hex-Rays,
        as we cannot download it for you automatically.

        Please first head to <https://my.hex-rays.com> and log in with or register your IDA account.

        If you do not yet have an IDA license, click on the "Shop" tab, press "+ Add item",
        select "IDA Free Plan" under "Product offering", then fill in your billing information.

        Once you have acquired your license or if you have a pre-existing license,
        click on the "Download center" tab, select version "${finalAttrs.version}"
        and download "SDK Pro" under the section "SDK and Utilities".

        Once your SDK has been downloaded, you can add it to your Nix store by running either
          nix-store --add-fixed sha256 ${sdkName}
        or
          nix-prefetch-url --type sha256 file:///path/to/${sdkName}
      '';
    };

    nativeBuildInputs = [ libarchive ];

    unpackCmd = "bsdtar -xf $curSrc";

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out

      runHook postInstall
    '';

    meta = {
      description = "SDK for the IDA decompiler and disassembler";
      homepage = "https://hex-rays.com";
      license = with lib.licenses; [ unfree ];
      platforms = with lib.platforms; linux ++ darwin ++ windows;
      maintainers = with lib.maintainers; [ pluiedev ];
    };
  }
)
