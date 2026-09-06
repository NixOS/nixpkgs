{
  lib,
  stdenv,
  fetchurl,
  libx11,
  libxinerama,
  imlib2,
}:

stdenv.mkDerivation {
  pname = "imlibsetroot";
  version = "1.2";
  src = fetchurl {
    url = "https://robotmonkeys.net/wp-content/uploads/2010/03/imlibsetroot-12.tar.gz";
    sha256 = "8c1b3b7c861e4d865883ec13a96b8e4ab22464a87d4e6c67255b17a88e3cfd1c";
  };

  buildInputs = [
    libx11
    imlib2
    libxinerama
  ];

  buildPhase = ''
    runHook preBuild

    gcc -g imlibsetroot.c -o imlibsetroot              \
      -I${imlib2.dev}/include -L${imlib2}/lib -lImlib2 \
      -I${libx11.dev}/include -lXinerama -lX11

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D -m 0755 imlibsetroot -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Xinerama Aware Background Changer";
    homepage = "http://robotmonkeys.net/2010/03/30/imlibsetroot/";
    license = lib.licenses.mitAdvertising;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dwarfmaster ];
    mainProgram = "imlibsetroot";
  };
}
