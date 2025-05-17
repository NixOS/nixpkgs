{
  stdenv,
  fetchurl,
  rpm,
  lib,
  cpio,
  libassuan,
  libgpg-error,
  pcsclite,
}:

let
  libassuan_2_5_7 = libassuan.overrideAttrs (oldAttrs: {
    src = fetchurl {
      url = "https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.7.tar.bz2";
      sha256 = "sha256-AQMIH/wng4ouUEeRU8oQXoc9PWXYqVkygunJTH5q+3Y=";
    };
  });
in

stdenv.mkDerivation rec {
  pname = "libpkcs11-dnie";
  version = "1.6.8-1";

  src = fetchurl {
    url = "https://www.dnielectronico.es/descargas/distribuciones_linux/libpkcs11-dnie-${version}.x86_64.rpm";
    sha256 = "8081e17e827f3dbf89db3f6fb73bc021962c6d5e98b327ee4a20bcabb778a231";
  };

  dontUnpack = true;
  nativeBuildInputs = [
    rpm
    cpio
  ];

  buildInputs = [
    libassuan_2_5_7
    libgpg-error
    pcsclite.lib
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    mkdir -p $out

    rpm2cpio $src | cpio -idmv

    mkdir -p $out/lib
    cp -r ./usr/lib64/* $out/lib

    mkdir -p $out/share
    cp -r ./usr/share/* $out/share

    # Changing library targets and search paths
    patchelf --set-rpath ${pcsclite.lib}/lib:${stdenv.cc.cc.lib}/lib $out/lib/libpkcs11-dnie-cryptopp.so.0.0.0
    patchelf --set-rpath ${pcsclite.lib}/lib $out/lib/libpkcs11-dnie-asn1.so.0.0.0
    patchelf --set-rpath ${pcsclite.lib}/lib $out/lib/libpkcs11-dnie-asn1skeletons.so.0.0.0
    patchelf --set-rpath ${pcsclite.lib}/lib:${stdenv.cc.cc.lib}/lib:${libassuan_2_5_7}/lib:${libgpg-error}/lib:$out/lib $out/lib/libpkcs11-dnie.so

    echo -e "\033[38;5;214m\n[!] Important information for using DNIe / Información importante para usar el DNIe:\n
    [!] For complete installation instructions, please consult $out/share/libpkcs11-dnie/install_dnie/launch.html
    [!] The libpkcs11-dnie.so resides in $out/lib/libpkcs11-dnie.so\033[0m"

    echo -e "\033[38;5;214m
    [!] Para instrucciones completas, consultar: $out/share/libpkcs11-dnie/install_dnie/launch.html
    [!] La librería libpkcs11-dnie.so se encuentra en: $out/lib/libpkcs11-dnie.so"

    echo -e '\033[38;5;214m
    [!] If you are on NixOS, you should use the option programs.firefox.policies.SecurityDevices to add the module declaratively:
    [!] After rebuilding your configuration, you might have to reboot your machine.

    services.pcscd.enable = true;
    programs.firefox = {
      enable = true;
      policies = {
        SecurityDevices = {
          Add = {
            "PKCS#11 DNIe" = "''${pkgs.libpkcs11-dnie}/lib/libpkcs11-dnie.so";
          };
        };
      };
    };
    \033[0m'

  '';

  meta = {
    description = "PKCS#11 module for electronic identification with the Spanish DNIe";
    homepage = "https://www.dnielectronico.es/PortalDNIe/PRF1_Cons02.action?pag=REF_1112";
    maintainers = with lib.maintainers; [ alexland7219 ];

    # Package is source-available (https://www.sede.fnmt.gob.es/stceres)
    license = lib.licenses.free;
  };
}
