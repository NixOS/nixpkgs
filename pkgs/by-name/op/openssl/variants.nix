{
  lib,
  stdenv,
  oqs-provider,
}:

let
  v3_6 = {
    version = "3.6.1";
    hash = "sha256-sb/tzVson/Iq7ofJ1gD1FXZ+v0X3cWjLbWTyMfUYqC4=";
    patches = [
      ./3.0/nix-ssl-cert-file.patch
      ./3.0/openssl-disable-kernel-detection.patch

      (
        if stdenv.hostPlatform.isDarwin then
          ./3.5/use-etc-ssl-certs-darwin.patch
        else
          ./3.5/use-etc-ssl-certs.patch
      )
    ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      ./3.5/fix-mingw-linking.patch
    ]
    ++ lib.optional stdenv.hostPlatform.isCygwin ./openssl-3.0.18-skip-dllmain-detach.patch;
  };
in
{
  v1_1 = {
    version = "1.1.1w";
    hash = "sha256-zzCYlQy02FOtlcCEHx+cbT3BAtzPys1SHZOSUgi3asg=";
    patches = [
      ./1.1/nix-ssl-cert-file.patch

      (
        if stdenv.hostPlatform.isDarwin then
          ./1.1/use-etc-ssl-certs-darwin.patch
        else
          ./1.1/use-etc-ssl-certs.patch
      )
    ];
  };

  v3 = {
    version = "3.0.19";
    hash = "sha256-+lpBQ7iq4YvlPvLzyvKaLgdHQwuLx00y2IM1uUq2MHI=";
    patches = [
      ./3.0/nix-ssl-cert-file.patch
      ./3.0/openssl-disable-kernel-detection.patch

      (
        if stdenv.hostPlatform.isDarwin then ./use-etc-ssl-certs-darwin.patch else ./use-etc-ssl-certs.patch
      )
    ]
    ++ lib.optional stdenv.hostPlatform.isCygwin ./openssl-3.0.18-skip-dllmain-detach.patch;
  };

  v3_5 = {
    version = "3.5.5";
    hash = "sha256-soyRUyqLZaH5g7TCi3SIF05KAQCOKc6Oab14nyi8Kok=";
    patches = [
      ./3.0/nix-ssl-cert-file.patch
      ./3.0/openssl-disable-kernel-detection.patch

      (
        if stdenv.hostPlatform.isDarwin then
          ./3.5/use-etc-ssl-certs-darwin.patch
        else
          ./3.5/use-etc-ssl-certs.patch
      )
    ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      ./3.5/fix-mingw-linking.patch
    ]
    ++ lib.optional stdenv.hostPlatform.isCygwin ./openssl-3.0.18-skip-dllmain-detach.patch;
  };

  inherit v3_6;

  oqs = v3_6 // {
    overrideArgs = {
      providers = [
        {
          name = "oqsprovider";
          package = oqs-provider;
        }
      ];
      autoloadProviders = true;
      extraINIConfig = {
        tls_system_default = {
          Groups = "X25519MLKEM768:X25519:P-256:X448:P-521:ffdhe2048:ffdhe3072";
        };
      };
    };
  };

  legacy = v3_6 // {
    overrideArgs = {
      conf = ./3.0/legacy.cnf;
    };
  };
}
