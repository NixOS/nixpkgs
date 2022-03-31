# Based on previous attempts:
#  -  <https://github.com/msteen/nixos-vsliveshare/blob/master/pkgs/vsliveshare/default.nix>
#  -  <https://github.com/NixOS/nixpkgs/issues/41189>
{ lib, gccStdenv, vscode-utils
, jq, autoPatchelfHook, bash, makeWrapper
, dotnet-sdk_3, curl, gcc, icu, libkrb5, libsecret, libunwind, libX11, lttng-ust, openssl, util-linux, zlib
, desktop-file-utils, xprop, xsel
}:

with lib;

let
  # https://docs.microsoft.com/en-us/visualstudio/liveshare/reference/linux#install-prerequisites-manually
  libs = [
    # .NET Core
    openssl
    libkrb5
    zlib
    icu

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
    version = "1.0.5043";
    sha256 = "OdFOFvidUV/trySHvF8iELPNVP2kq8+vZQ4q4Nf7SiQ=";
  };
}).overrideAttrs({ nativeBuildInputs ? [], buildInputs ? [], ... }: {
  nativeBuildInputs = nativeBuildInputs ++ [
    jq
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = buildInputs ++ libs;

  # Using a patch file won't work, because the file changes too often, causing the patch to fail on most updates.
  # Rather than patching the calls to functions, we modify the functions to return what we want,
  # which is less likely to break in the future.
  postPatch = ''
    sed -i \
      -e 's/updateExecutablePermissionsAsync() {/& return;/' \
      -e 's/isInstallCorrupt(traceSource, manifest) {/& return false;/' \
      out/prod/extension-prod.js

    declare ext_unique_id
    ext_unique_id="$(basename "$out")"

    # Fix extension attempting to write to 'modifiedInternalSettings.json'.
    # Move this write to the tmp directory indexed by the nix store basename.
    substituteInPlace out/prod/extension-prod.js \
      --replace "path.resolve(constants_1.EXTENSION_ROOT_PATH, './modifiedInternalSettings.json')" \
                "path.join(os.tmpdir(), '$ext_unique_id-modifiedInternalSettings.json')"

    # Fix extension attempting to write to 'vsls-agent.lock'.
    # Move this write to the tmp directory indexed by the nix store basename.
    substituteInPlace out/prod/extension-prod.js \
      --replace "path + '.lock'" \
                "__webpack_require__('path').join(__webpack_require__('os').tmpdir(), '$ext_unique_id-vsls-agent.lock')"

    # Hardcode executable paths
    echo '#!/bin/sh' >node_modules/@vsliveshare/vscode-launcher-linux/check-reqs.sh
    substituteInPlace node_modules/@vsliveshare/vscode-launcher-linux/install.sh \
      --replace desktop-file-install ${desktop-file-utils}/bin/desktop-file-install
    substituteInPlace node_modules/@vsliveshare/vscode-launcher-linux/uninstall.sh \
      --replace update-desktop-database ${desktop-file-utils}/bin/update-desktop-database
    substituteInPlace node_modules/@vsliveshare/vscode-launcher-linux/vsls-launcher \
      --replace /bin/bash ${bash}/bin/bash
    substituteInPlace out/prod/extension-prod.js \
      --replace xprop ${xprop}/bin/xprop \
      --replace "'xsel'" "'${xsel}/bin/xsel'"
  '';

  postInstall = ''
    cd $out/share/vscode/extensions/ms-vsliveshare.vsliveshare

    bash -s <<ENDSUBSHELL
    shopt -s extglob

    # A workaround to prevent the journal filling up due to diagnostic logging.
    # See: https://github.com/MicrosoftDocs/live-share/issues/1272
    # See: https://unix.stackexchange.com/questions/481799/how-to-prevent-a-process-from-writing-to-the-systemd-journal
    gcc -fPIC -shared -ldl -o dotnet_modules/noop-syslog.so ${./noop-syslog.c}

    # Normally the copying of the right executables is done externally at a later time,
    # but we want it done at installation time.
    cp dotnet_modules/exes/linux-x64/* dotnet_modules

    # The required executables are already copied over,
    # and the other runtimes won't be used and thus are just a waste of space.
    rm -r dotnet_modules/exes dotnet_modules/runtimes/!(linux-x64|unix)

    # Not all executables and libraries are executable, so make sure that they are.
    jq <package.json '.executables.linux[]' -r | xargs chmod +x

    # Lock the extension downloader.
    touch install-linux.Lock externalDeps-linux.Lock
    ENDSUBSHELL
  '';

  postFixup = ''
    # We cannot use `wrapProgram`, because it will generate a relative path,
    # which will break when copying over the files.
    mv dotnet_modules/vsls-agent{,-wrapped}
    makeWrapper $PWD/dotnet_modules/vsls-agent{-wrapped,} \
      --prefix LD_LIBRARY_PATH : "${makeLibraryPath libs}" \
      --set LD_PRELOAD $PWD/dotnet_modules/noop-syslog.so \
      --set DOTNET_ROOT ${dotnet-sdk_3}
  '';

  meta = {
    description = "Live Share lets you achieve greater confidence at speed by streamlining collaborative editing, debugging, and more in real-time during development";
    homepage = "https://aka.ms/vsls-docs";
    license = licenses.unfree;
    maintainers = with maintainers; [ jraygauthier V ];
    platforms = [ "x86_64-linux" ];
  };
})
