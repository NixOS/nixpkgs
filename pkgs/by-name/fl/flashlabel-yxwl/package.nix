{
  autoPatchelfHook,
  cups,
  lib,
  requireFile,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "flashlabel-yxwl";
  version = "1.2.3";

  # The source URL redirects to Google Drive, which resists direct downloads.
  src = requireFile {
    name = "A4_Linux_Driver_Ver${version}.run";
    url = "https://flashlabel.net/YXWL-A4driver-linux";
    hash = "sha256-LqVQKkh6B+zGl5swknHefaB0EfHYVXXEEqDb6NUaxqc=";
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
        - C801
        - C80H
        - C80S1
        - C80Y1
        - D80
        - D80 Pro
        - K80
        - S8
        - ST80
        - ST80K
        - ST81
        - ST82
        - ST83
        - T8810
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
