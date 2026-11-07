{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libgcc,
  makeWrapper,
  openssl,
  versionCheckHook,
}:

let
  inherit (stdenv.hostPlatform) system;

  pname = "jcode";
  version = "0.99.1";

  # jcode ships prebuilt release archives, one per platform. The archive
  # layout differs: only the x86_64-linux archive bundles a launcher shell
  # script next to the real ELF binary, every other archive contains the
  # binary alone.
  archiveName = {
    x86_64-linux = "jcode-linux-x86_64.tar.gz";
    aarch64-linux = "jcode-linux-aarch64.tar.gz";
    x86_64-darwin = "jcode-macos-x86_64.tar.gz";
    aarch64-darwin = "jcode-macos-aarch64.tar.gz";
  };

  hashes = {
    x86_64-linux = "sha256-CyphLel8bgGubeHAz/VVs0YM+DZNGhHS+GSfwMnXoeY=";
    aarch64-linux = "sha256-9m/7r3xMAST0XWyGFlcRRt64UJuL7vLowNdsw13am5E=";
    x86_64-darwin = "sha256-19U8QLHhBZJuBt9aoCwPCCYW1gK70g4MMYJIzj/a1Mk=";
    aarch64-darwin = "sha256-NiMWTVGLDJ1EOrBwUghCRLN56KM3cDfbZ9I4IiD07RQ=";
  };

  platforms = builtins.attrNames archiveName;
in
stdenv.mkDerivation {
  inherit pname version;

  src =
    if builtins.elem system platforms then
      fetchurl {
        url = "https://github.com/1jehuang/jcode/releases/download/v${version}/${archiveName.${system}}";
        hash = hashes.${system};
      }
    else
      throw "jcode is not supported on ${system}";

  strictDeps = true;
  __structuredAttrs = true;

  # The release archives unpack into a flat directory without a top-level
  # folder, so point the unpack phase at the current directory.
  sourceRoot = ".";

  nativeBuildInputs = [
    makeWrapper
    versionCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # The release binaries link against libgcc_s.so.1. The aarch64-linux
  # archive additionally links OpenSSL dynamically (libssl.so.3 and
  # libcrypto.so.3); the x86_64-linux archive bundles it statically.
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libgcc
    openssl
  ];

  dontStrip = stdenv.hostPlatform.isDarwin;

  # The x86_64-linux archive contains a launcher script ("jcode-linux-x86_64")
  # next to the real binary ("jcode-linux-x86_64.bin"). Every other archive
  # contains the binary alone. Pick the binary by looking at the extracted
  # files rather than by name, so that the layout works for all platforms.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/jcode $out/bin

    binary=""
    for f in *; do
      [ -f "$f" ] || continue
      magic="$(od -An -tx1 -N4 "$f" | tr -d ' \n')"
      case "$magic" in
        # ELF (Linux) and the 64/32-bit Mach-O little/big endian magics (macOS).
        7f454c46 | cffaedfe | cefaedfe | feedfacf | feedface | cafebabe)
          binary="$f"
          break
          ;;
      esac
    done

    if [ -z "$binary" ]; then
      echo "jcode: could not find the jcode binary in the release archive" >&2
      exit 1
    fi

    install -m755 "$binary" $out/libexec/jcode/jcode

    # Wrap the real binary so that LD_LIBRARY_PATH points at its directory,
    # mirroring the upstream launcher script. Telemetry is disabled by
    # default: the NixOS package must not opt users into anonymous usage
    # statistics without their consent.
    makeWrapper $out/libexec/jcode/jcode $out/bin/jcode \
      --prefix LD_LIBRARY_PATH : "$out/libexec/jcode" \
      --set-default JCODE_NO_TELEMETRY 1

    runHook postInstall
  '';

  doInstallCheck = true;

  versionCheckProgram = "${placeholder "out"}/bin/jcode";
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "High-performance coding agent harness for heavy multi-agent dev workflows";
    homepage = "https://github.com/1jehuang/jcode";
    changelog = "https://github.com/1jehuang/jcode/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = platforms;
    maintainers = [ ];
    mainProgram = "jcode";
  };
}
