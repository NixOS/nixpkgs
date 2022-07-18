{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
, makeWrapper
, zlib
, libX11
, libXrandr
, libXinerama
, libXcursor
, libXi
, libXext
, libGLU
, alsa-lib
, fontconfig
, AVFoundation
, Carbon
, Cocoa
, CoreAudio
, Kernel
, OpenGL
}:

stdenv.mkDerivation rec {
  pname = "foxotron";
  version = "2022-03-06";

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = "Foxotron";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-w66wi+aMwQa9akfNA/1cS6UmDXPWC4OPK9BIa9Kt47A=";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

  buildInputs = [ zlib ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libX11 libXrandr libXinerama libXcursor libXi libXext alsa-lib fontconfig libGLU ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ AVFoundation Carbon Cocoa CoreAudio Kernel OpenGL ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/foxotron}
    cp -R ${lib.optionalString stdenv.hostPlatform.isDarwin "Foxotron.app/Contents/MacOS/"}Foxotron \
      ../{config.json,Shaders,Skyboxes} $out/lib/foxotron/
    wrapProgram $out/lib/foxotron/Foxotron \
      --chdir "$out/lib/foxotron"
    ln -s $out/{lib/foxotron,bin}/Foxotron

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "General purpose model viewer";
    longDescription = ''
      ASSIMP based general purpose model viewer ("turntable") created for the
      Revision 2021 3D Graphics Competition.
    '';
    homepage = "https://github.com/Gargaj/Foxotron";
    license = licenses.unlicense;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
