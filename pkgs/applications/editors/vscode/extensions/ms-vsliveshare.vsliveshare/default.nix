# Based on previous attempts:
#  -  <https://github.com/msteen/nixos-vsliveshare/blob/master/pkgs/vsliveshare/default.nix>
#  -  <https://github.com/NixOS/nixpkgs/issues/41189>
{ lib, gccStdenv, vscode-utils
, autoPatchelfHook, bash, makeWrapper
, curl, gcc, libsecret, libunwind, libX11, lttng-ust, util-linux
, desktop-file-utils, xsel
}:

let
  # https://docs.microsoft.com/en-us/visualstudio/liveshare/reference/linux#install-prerequisites-manually
  libs = [
    # Credential Storage
    libsecret

    # NodeJS
    libX11

    # https://github.com/flathub/com.visualstudio.code.oss/issues/11#issuecomment-392709170
    libunwind
    lttng-ust
    curl

    # General
    gcc.cc.lib
    util-linux # libuuid
  ];

in ((vscode-utils.override { stdenv = gccStdenv; }).buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vsliveshare";
    publisher = "ms-vsliveshare";
    version = "1.0.5900";
    sha256 = "sha256-syVW/aS2ppJjg4OZaenzGM3lczt+sLy7prwsYFTDl9s=";
  };
}).overrideAttrs({ buildInputs ? [], ... }: {
  buildInputs = buildInputs ++ libs;

  # Using a patch file won't work, because the file changes too often, causing the patch to fail on most updates.
  # Rather than patching the calls to functions, we modify the functions to return what we want,
  # which is less likely to break in the future.
  postPatch = ''
    substituteInPlace extension.js \
      --replace "'xsel'" "'${xsel}/bin/xsel'"
  '';

  meta = {
    description = "Live Share lets you achieve greater confidence at speed by streamlining collaborative editing, debugging, and more in real-time during development";
    homepage = "https://aka.ms/vsls-docs";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.jraygauthier lib.maintainers.V ];
    platforms = [ "x86_64-linux" ];
  };
})
