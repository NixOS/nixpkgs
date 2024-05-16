{ stdenv
, fetchurl
, innoextract
, runtimeShell
, wineWow64Packages
, lib
}:

let
  version = "6.2.2";
  majorVersion = builtins.substring 0 1 version;
in
stdenv.mkDerivation rec {
  pname = "iscc";
  inherit version;
  src = fetchurl {
    url = "https://files.jrsoftware.org/is/${majorVersion}/innosetup-${version}.exe";
    hash = "sha256-gRfRDQCirTOhOQl46jhyhhwzDgh5FEEKY3eyLExbhWM=";
  };
  nativeBuildInputs = [
    innoextract
    wineWow64Packages.stable
  ];
  unpackPhase = ''
    runHook preUnpack
    innoextract $src
    runHook postUnpack
  '';
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp -r ./app/* "$out/bin"

    cat << 'EOF' > "$out/bin/${pname}"
    #!${runtimeShell}
    export PATH=${wineWow64Packages.stable}/bin:$PATH
    export WINEDLLOVERRIDES="mscoree=" # disable mono

    # Solves PermissionError: [Errno 13] Permission denied: '/homeless-shelter/.wine'
    export HOME=$(mktemp -d)

    wineInputFile=$(${wineWow64Packages.stable}/bin/wine winepath -w $1)
    ${wineWow64Packages.stable}/bin/wine "$out/bin/ISCC.exe" "$wineInputFile"
    EOF

    substituteInPlace $out/bin/${pname} \
      --replace "\$out" "$out"

    chmod +x "$out/bin/${pname}"

    runHook postInstall
  '';


  meta = with lib; {
    description = "A compiler for Inno Setup, a tool for creating Windows installers";
    homepage = "https://jrsoftware.org/isinfo.php";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ ];
    platforms = wineWow64Packages.stable.meta.platforms;
  };
}
