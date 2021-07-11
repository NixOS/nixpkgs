{ lib, stdenv
, fetchurl
, appimageTools
, makeWrapper
, electron_13
, libudev
, polkit
, xorg
}:

let
  electron = electron_13;
in
stdenv.mkDerivation rec {
  pname = "1password";
  version = "8.1.2-2.BETA";

  src = fetchurl {
    url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
    sha256 = "10rj2qahdqq76jm09cvw7g1bzrrh5pdy446yz2p0pf5n9hha8hp6";
  };

  buildInputs = [ polkit.bin ];
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -a {1Password-BrowserSupport,1Password-KeyringHelper} $out/bin
    cp -a {locales,resources} $out/share/${pname}
    cp -a resources/${pname}.desktop $out/share/applications
    cp -a resources/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=/opt/1Password/${pname}' 'Exec=${pname}'

    patchelf \
       --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
       --set-rpath ${lib.makeLibraryPath [stdenv.cc.cc.lib]}:$out/share/${pname} \
       $out/bin/{1Password-BrowserSupport,1Password-KeyringHelper}

    install -D -m0644 com.1password.1Password.policy \
      $out/share/polkit-1/actions/com.1password.1Password.policy

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc libudev xorg.libXtst ]}"
  '';

  meta = with lib; {
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ danieldk timstott savannidgerinel sebtm ];
    platforms = [ "x86_64-linux" ];
  };
}
