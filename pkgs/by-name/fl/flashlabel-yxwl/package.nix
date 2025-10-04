{
  autoPatchelfHook,
  cups,
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "flashlabel-yxwl";
  version = "1.2.1";

  src = fetchurl {
    url = "https://cdn.shopify.com/s/files/1/0771/1984/8732/files/A4_Linux_Driver_Ver1.2.1.run";
    hash = "sha256-qkc3NJ1dK0nJf+Q7xL7f1/+X0COWSWMEbH4luzaFARc=";
  };

  # The driver is distributed as a self-extracting executable consisting of a
  # shell script concatenated with a gzipped tar archive. The script hard codes
  # its length in the `lines` variable, which we read to locate the archive.
  unpackPhase = ''
    lines="$(sed 's/^lines=//; t; d' "$src")"
    tail --lines "+$lines" "$src" | tar --extract --gzip --strip-components=1
  '';

  patchPhase = ''
    runHook prePatch

    # Remove model from manufacturer name
    sed --in-place 's/\(^\*Manufacturer: "YXWL\) [^"]*\("$\)/\1\2/' *.ppd

    runHook postPatch
  '';

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ cups ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/lib/cups/filter
    mv {A80,A80H} $out/lib/cups/filter

    mkdir --parents $out/share/cups/model
    mv *.ppd $out/share/cups/model

    runHook postInstall
  '';

  postFixup = ''
    gzip --best $out/share/cups/model/*.ppd
  '';

  meta = {
    description = "CUPS driver for FlashLabel A4 thermal printers";
    longDescription = ''
      Supported models:

        - A80
        - A80H
        - A81
        - A81H
        - C80
        - C80H
        - D80
        - D80 Pro
        - Y8
        - Y8 Pro
        - Y80
    '';
    homepage = "https://help.flashlabel.com/support/solutions/articles/150000191214";
    downloadPage = "https://flashlabel.net/YXWL-A4driver-linux";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      altsalt
      AndrewKvalheim
    ];
  };
}
