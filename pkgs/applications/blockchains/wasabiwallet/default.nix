{ lib, stdenv
, autoPatchelfHook
, makeWrapper
, fetchurl
, makeDesktopItem
<<<<<<< HEAD
, lttng-ust_2_12
, fontconfig
=======
, curl
, dotnetCorePackages
, lttng-ust_2_12
, fontconfig
, krb5
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openssl
, xorg
, zlib
}:

let
<<<<<<< HEAD
  # These libraries are dynamically loaded by the application,
  # and need to be present in LD_LIBRARY_PATH
  runtimeLibs = [
    fontconfig.lib
=======
  dotnet-runtime = dotnetCorePackages.runtime_6_0;
  # These libraries are dynamically loaded by the application,
  # and need to be present in LD_LIBRARY_PATH
  runtimeLibs = [
    curl
    fontconfig.lib
    krb5
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    openssl
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libICE
    xorg.libSM
    zlib
  ];
in
stdenv.mkDerivation rec {
  pname = "wasabiwallet";
<<<<<<< HEAD
  version = "2.0.4";

  src = fetchurl {
    url = "https://github.com/zkSNACKs/WalletWasabi/releases/download/v${version}/Wasabi-${version}.tar.gz";
    sha256 = "sha256-VYyf9rKBRPpnxuaeO6aAq7cQwDfBRLRbH4SlPS+bxFQ=";
=======
  version = "2.0.3";

  src = fetchurl {
    url = "https://github.com/zkSNACKs/WalletWasabi/releases/download/v${version}/Wasabi-${version}.tar.gz";
    sha256 = "sha256-RlWaeOK6XqxyCIQQp1/X6iG9t7f3ER5K+S3ZvPg6wBg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontBuild = true;

  desktopItem = makeDesktopItem {
    name = "wasabi";
    exec = "wasabiwallet";
    desktopName = "Wasabi";
    genericName = "Bitcoin wallet";
    comment = meta.description;
    categories = [ "Network" "Utility" ];
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = runtimeLibs ++ [
    lttng-ust_2_12
  ];

  installPhase = ''
    mkdir -p $out/opt/${pname} $out/bin $out/share/applications
    cp -Rv . $out/opt/${pname}

<<<<<<< HEAD
    makeWrapper "$out/opt/${pname}/wassabee" "$out/bin/${pname}" \
      --suffix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath runtimeLibs}"

    makeWrapper "$out/opt/${pname}/wassabeed" "$out/bin/${pname}d" \
=======
    makeWrapper "${dotnet-runtime}/bin/dotnet" "$out/bin/${pname}" \
      --add-flags "$out/opt/${pname}/WalletWasabi.Fluent.Desktop.dll" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --suffix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath runtimeLibs}"

    cp -v $desktopItem/share/applications/* $out/share/applications
  '';

  meta = with lib; {
    description = "Privacy focused Bitcoin wallet";
    homepage = "https://wasabiwallet.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mmahut ];
  };
}
