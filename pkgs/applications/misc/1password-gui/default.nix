{
  stdenv,
  callPackage,
  channel ? "stable",
  fetchurl,
  lib,
  # This is only relevant for Linux, so we need to pass it through
  polkitPolicyOwners ? [ ],
}:

let
  pname = "1password";
  version = if channel == "stable" then "8.10.54" else "8.10.56-1.BETA";

  sources = {
    stable = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-kpFO59DPBCgD3EdYxq1tom/5/misBsafbsJS+Wj2l3I=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-ZZKuPxshI9yLSUMccpXaQDbu8gTvFCaS68tqMstZHJE=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-Xha7aOuBvG+R1K48gdPj/v4URuIEYv2le+TCxwDnCwk=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-ukfx7V8totRIyHpmjWDR2O9IDkAY3uq/0jtGPXiZ5Bw=";
      };
    };
    beta = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-25vBmc3AJv4NTI2oOrnTR5pMBMK+wx1s/eg5g8jjtb8=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-MLnXEqJM9E+2GAXlqX2dGUzFVk0xv5pmUzLdncakWf8=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-W7VA7DFpIY2D+0ZqNaLfOzTTqryqpA1iy0+yACNrPlg=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-ZH7xuL0SrkncxI/ngDIYHf4bLwUyTQC4Ki3HgUVza+I=";
      };
    };
  };

  src = fetchurl {
    inherit
      (sources.${channel}.${stdenv.system} or (throw "unsupported system ${stdenv.hostPlatform.system}"))
      url
      hash
      ;
  };

  meta = {
    # Requires to be installed in "/Application" which is not possible for now (https://github.com/NixOS/nixpkgs/issues/254944)
    broken = stdenv.hostPlatform.isDarwin;
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      khaneliman
      timstott
      savannidgerinel
      sebtm
    ];
    platforms = builtins.attrNames sources.${channel};
    mainProgram = "1password";
  };

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      meta
      polkitPolicyOwners
      ;
  }
