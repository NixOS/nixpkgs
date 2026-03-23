{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeBinaryWrapper,
  jq,
  dotnet-runtime,
  zlib,
  libzen,
}:

stdenv.mkDerivation {
  pname = "avdump3";
  version = "8293_stable";

  src = fetchzip {
    url = "https://cdn.anidb.net/client/avdump3/avdump3_8293_stable.zip";
    hash = "sha256-H9Sn3I4S9CmymKIMHVagDy+7svHs285S3EJgYQo+ks0=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
    jq
  ];

  buildInputs = [
    zlib
    libzen
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/avdump3 $out/bin
    mv * $out/share/avdump3

    # The app targets net6.0, which is EOL. Allow roll-forward to whatever
    # major version dotnet-runtime provides.
    jq '.runtimeOptions.rollForward = "major"' \
      $out/share/avdump3/AVDump3CL.runtimeconfig.json > tmp.json
    mv tmp.json $out/share/avdump3/AVDump3CL.runtimeconfig.json

    makeBinaryWrapper ${dotnet-runtime}/bin/dotnet $out/bin/avdump3 \
      --add-flags $out/share/avdump3/AVDump3CL.dll

    runHook postInstall
  '';

  meta = {
    mainProgram = "avdump3";
    description = "Tool for extracting audio/video metadata from media files and uploading it to AniDB";
    longDescription = ''
      AVDump is a tool to extract meta information from media files while at the
      same time calculating multiple hashes. Based on that information reports
      can be generated in multiple forms. Of particular interest is the ability
      to send those reports back to AniDB and thereby quickly filling in missing
      metadata for new files.
    '';
    homepage = "https://wiki.anidb.net/Avdump3";
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
    # partial source code available under MIT license at https://github.com/DvdKhl/AVDump3
    license = with lib.licenses; [
      mit
      unfree
    ];
    maintainers = with lib.maintainers; [ kini ];
    # NOTE: aarch64-linux may also work but hasn't been tested; co-maintainers welcome.
    platforms = [ "x86_64-linux" ];
  };
}
