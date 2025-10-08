{
  autoPatchelfHook,
  c-ares,
  curl,
  darwin,
  expat,
  fetchurl,
  glibc,
  icu60,
  jq,
  lib,
  libiconv,
  libredirect,
  libxcrypt-legacy,
  libxml2,
  makeWrapper,
  openssl,
  stdenv,
  unzip,
  xercesc,
  zlib,
  acceptBroadcomEula ? false,
}:

let
  # Returns the base URL for the given tool ID.
  mkBaseUrl = toolId: "https://developer.broadcom.com/tools/${toolId}/latest";
  ovftoolId = "open-virtualization-format-ovf-tool";

  # Use browser devtools to figure out how this works.
  fetchFromBroadcom =
    {
      fileName,
      version,
      toolId ? ovftoolId,
      artifactId ? 21342,
      fileType ? "Download",
      source ? "",
      hash ? "",
    }:
    let
      requestJson = builtins.toJSON {
        inherit
          fileName
          artifactId
          fileType
          source
          ;
      };
    in
    fetchurl {
      name = fileName;
      url =
        (mkBaseUrl toolId)
        + "?p_p_id=SDK_AND_TOOL_DETAILS_INSTANCE_iwlk&p_p_lifecycle=2&p_p_resource_id=documentDownloadArtifact";
      curlOptsList = [
        "--json"
        requestJson
      ];
      downloadToTemp = true;
      nativeBuildInputs = [ jq ];
      postFetch = ''
        # Try again with the new URL
        urls="$(jq -r 'if (.success == true) then .data.downloadUrl else error(. | tostring) end' < "$downloadedFile" || exit $?)" \
          downloadToTemp="" \
          curlOptsList="" \
          curlOpts="" \
          postFetch="" \
          exec "$SHELL" "''${BASH_ARGV[@]}"
      '';
      inherit hash;
    };

  ovftoolSystems = {
    "x86_64-linux" = rec {
      version = "4.6.3-24031167";
      fileName = "VMware-ovftool-${version}-lin.x86_64.zip";
      hash = "sha256-NEwwgmEh/mrZkMMhI+Kq+SYdd3MJ0+IBLdUhd1+kPow=";
    };
    "x86_64-darwin" = rec {
      version = "4.6.3-24031167";
      fileName = "VMware-ovftool-${version}-mac.x64.zip";
      hash = "sha256-vhACcc4tjaQhvKwZyWkgpaKaoC+coWGl1zfSIC6WebM=";
    };
  };

  ovftoolSystem = ovftoolSystems.${stdenv.system} or (throw "unsupported system ${stdenv.system}");

  # Regrettably, we need to compile this version or else ovftool complains about unknown symbols.
  ovftool-xercesc = xercesc.overrideAttrs (prev: rec {
    version = "3.2.5";
    src = fetchurl {
      url = lib.replaceStrings [ prev.version ] [ version ] prev.src.url;
      hash = "sha256-VFz8zmxOdVIHvR8n4xkkHlDjfAwnJQ8RzaEWAY8e8PU=";
    };
  });
in
stdenv.mkDerivation (final: {
  pname = "ovftool";
  inherit (ovftoolSystem) version;

  src =
    if acceptBroadcomEula then
      fetchFromBroadcom {
        inherit (ovftoolSystem) fileName version hash;
      }
    else
      throw ''
        See the following URL for terms of using this software:
        ${mkBaseUrl ovftoolId}

        Use `${final.pname}.override { acceptBroadcomEula = true; }` if you accept Broadcom's terms
        and would like to use this package.
      '';

  buildInputs = [
    c-ares
    expat
    icu60
    libiconv
    libxcrypt-legacy
    ovftool-xercesc
    zlib
    curl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glibc
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libxml2
  ];

  nativeBuildInputs = [
    unzip
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  postUnpack = ''
    # The linux package wraps ovftool.bin with ovftool. Wrapping
    # below in installPhase.
    # Rename to ovftool on install for all systems to ovftool
    if [[ -f ovftool.bin ]]; then
      mv -v ovftool.bin ovftool
    fi
  '';

  installPhase = ''
    runHook preInstall

    # Based on https://aur.archlinux.org/packages/vmware-ovftool/
    # with the addition of a libexec directory and a Nix-style binary wrapper.

    # Almost all libs in the package appear to be VMware proprietary except for
    # libgoogleurl and libcurl.
    #
    # FIXME: Replace libgoogleurl? Possibly from Chromium?
    # FIXME: Tell VMware to use a modern version of OpenSSL on macOS. As of ovftool
    # v4.6.3 ovftool uses openssl-1.0.2zj which in seems to be the extended
    # support LTS release: https://www.openssl.org/support/contracts.html

    # Install all libs that are not patched in preFixup.
    # Darwin dylibs are under `lib` in the zip.
    install -m 755 -d "$out/lib"
    install -m 644 -t "$out/lib" \
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    libgoogleurl.so.59 \
    libssoclient.so \
    libvim-types.so \
    libvmacore.so \
    libvmomi.so
  ''
  # macOS still relies on OpenSSL 1.0.2 as of v4.6.3, but Linux is in the clear
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    lib/libcrypto.1.0.2.dylib \
    lib/libgoogleurl.59.0.30.45.2.dylib \
    lib/libssl.1.0.2.dylib \
    lib/libssoclient.dylib \
    lib/libvim-types.dylib \
    lib/libvmacore.dylib \
    lib/libvmomi.dylib
  ''
  + ''
    # Install libexec binaries
    # ovftool expects to be run relative to certain directories, namely `env`.
    # Place the binary and those dirs in libexec.
    install -m 755 -d "$out/libexec"
    install -m 755 -t "$out/libexec" ovftool
    [ -f ovftool.bin ] && install -m 755 -t "$out/libexec" ovftool.bin
    install -m 644 -t "$out/libexec" icudt44l.dat

    # Install other libexec resources that need to be relative to the `ovftool`
    # binary.
    for subdir in "certs" "env" "env/en" "schemas/DMTF" "schemas/vmware"; do
      install -m 755 -d "$out/libexec/$subdir"
      install -m 644 -t "$out/libexec/$subdir" "$subdir"/*.*
    done

    # Install EULA/OSS files
    install -m 755 -d "$out/share/licenses"
    install -m 644 -t "$out/share/licenses" \
      "vmware.eula" \
      "vmware-eula.rtf" \
      "README.txt" \
      "open_source_licenses.txt"

    # Install Docs
    install -m 755 -d "$out/share/doc"
    install -m 644 -t "$out/share/doc" "README.txt"

    # Install final executable
    install -m 755 -d "$out/bin"
    makeWrapper "$out/libexec/ovftool" "$out/bin/ovftool" \
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    --prefix LD_LIBRARY_PATH : "$out/lib"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    --prefix DYLD_LIBRARY_PATH : "$out/lib"
  ''
  + ''
    runHook postInstall
  '';

  preFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      addAutoPatchelfSearchPath "$out/lib"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      change_args=()

      # Change relative @loader_path dylibs to absolute paths.
      for lib in $out/lib/*.dylib; do
        libname=$(basename $lib)
        change_args+=(-change "@loader_path/lib/$libname" "$out/lib/$libname")
      done

      # Patches for ovftool binary
      change_args+=(-change /usr/lib/libiconv.2.dylib ${libiconv}/lib/libiconv.2.dylib)
      change_args+=(-change /usr/lib/libxml2.2.dylib ${libxml2}/lib/libxml2.2.dylib)
      change_args+=(-change /usr/lib/libz.1.dylib ${zlib}/lib/libz.1.dylib)
      change_args+=(-change @loader_path/lib/libcares.2.dylib ${c-ares}/lib/libcares.2.dylib)
      change_args+=(-change @loader_path/lib/libexpat.dylib ${expat}/lib/libexpat.dylib)
      change_args+=(-change @loader_path/lib/libicudata.60.2.dylib ${icu60}/lib/libicudata.60.2.dylib)
      change_args+=(-change @loader_path/lib/libicuuc.60.2.dylib ${icu60}/lib/libicuuc.60.2.dylib)
      change_args+=(-change @loader_path/lib/libxerces-c-3.2.dylib ${ovftool-xercesc}/lib/libxerces-c.dylib)

      # lolwut
      change_args+=(-change @GOBUILD_CAYMAN_CURL_ROOT@/apple_mac64/lib/libcurl.4.dylib ${curl.out}/lib/libcurl.4.dylib)

      # Patch binary
      install_name_tool "''${change_args[@]}" "$out/libexec/ovftool"
      otool -L "$out/libexec/ovftool"

      # Additional patches for ovftool dylibs
      change_args+=(-change /usr/lib/libresolv.9.dylib ${lib.getLib darwin.libresolv}/lib/libresolv.9.dylib)
      change_args+=(-change @loader_path/libcares.2.dylib ${c-ares}/lib/libcares.2.dylib)
      change_args+=(-change @loader_path/libexpat.dylib ${expat}/lib/libexpat.dylib)
      change_args+=(-change @loader_path/libicudata.60.2.dylib ${icu60}/lib/libicudata.60.2.dylib)
      change_args+=(-change @loader_path/libicuuc.60.2.dylib ${icu60}/lib/libicuuc.60.2.dylib)
      change_args+=(-change @loader_path/libxerces-c-3.2.dylib ${ovftool-xercesc}/lib/libxerces-c.dylib)

      # Add new absolute paths for other libs to all libs
      for lib in $out/lib/*.dylib; do
        libname=$(basename $lib)
        change_args+=(-change "@loader_path/$libname" "$out/lib/$libname")
      done

      # Patch all libs
      for lib in $out/lib/*.dylib; do
        libname=$(basename $lib)
        install_name_tool -id "$libname" "$lib"
        install_name_tool "''${change_args[@]}" "$lib"
        otool -L "$lib"
      done
    '';

  # These paths are need for install check tests
  propagatedSandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow file-read* (subpath "/usr/share/locale"))
    (allow file-read* (subpath "/var/db/timezone"))
    (allow file-read* (subpath "/System/Library/TextEncodings"))
  '';

  # Seems to get stuck and return 255, but works outside the sandbox
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  postInstallCheck =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      export HOME=$TMPDIR
      # Construct a dummy /etc/passwd file - ovftool attempts to determine the
      # user's "real" home using this
      DUMMY_PASSWD="$HOME/dummy-passwd"
      cat > $DUMMY_PASSWD <<EOF
      $(whoami)::$(id -u):$(id -g)::$HOME:$SHELL
      EOF
      export DYLD_INSERT_LIBRARIES="${libredirect}/lib/libredirect.dylib"
      export NIX_REDIRECTS="/etc/passwd=$(realpath "$DUMMY_PASSWD")"
    ''
    + ''
      mkdir -p ovftool-check && cd ovftool-check

      ovftool_with_args="$out/bin/ovftool --X:logToConsole"

      # There are non-fatal warnings if we don't provide this, due to the sandbox.
      export LC_ALL=C

      # `installCheckPhase.ova` is a NixOS 22.11 image (doesn't actually matter)
      # with a 1 MiB root disk that's all zero. Make sure that it converts
      # properly.

      set -x
      $ovftool_with_args --schemaValidate ${./installCheckPhase.ova}
      $ovftool_with_args --sourceType=OVA --targetType=OVF ${./installCheckPhase.ova} nixos.ovf

      # Test that the output files are there
      test -f nixos.ovf
      test -f nixos.mf
      test -f nixos-disk1.vmdk

      $ovftool_with_args --schemaValidate nixos.ovf
      set +x
    '';

  meta = with lib; {
    description = "VMware tools for working with OVF, OVA, and VMX images";
    homepage = "https://developer.vmware.com/web/tool/ovf-tool/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      numinit
      thanegill
    ];
    platforms = builtins.attrNames ovftoolSystems;
    mainProgram = "ovftool";
    knownVulnerabilities = lib.optionals (stdenv.hostPlatform.isDarwin) [
      "The bundled version of openssl 1.0.2zj in ovftool for Darwin has open vulnerabilities."
      "https://openssl-library.org/news/vulnerabilities-1.0.2/"
      "CVE-2024-0727"
      "CVE-2024-5535"
      "CVE-2024-9143"
      "CVE-2024-13176"
    ];
  };
})
