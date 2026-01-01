{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  pipewire,
  vulkan-loader,
  wayland,
  libGL,
  xorg,
}:

<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "coppwr";
  version = "1.7.1";
=======
rustPlatform.buildRustPackage rec {
  pname = "coppwr";
  version = "1.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "coppwr";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-L0MpMh3HuWX0zxG50OGZDa+wX5E55/dU6jt6Iei99Ho=";
  };

  cargoHash = "sha256-tcGyoPVoJFhbXZFe23d00Z7FUwIo5J02EfPTBzCGE64=";
=======
    tag = version;
    hash = "sha256-9oFWX44jToJh0vJaDV/KZXVNQgLG0lr1iA+0hInAhLA=";
  };

  cargoHash = "sha256-Fq8I1pt83yqrjiA4VXA+z7o2LFTac2SonAwTycQRP8M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxkbcommon
    pipewire
    vulkan-loader
    wayland
    libGL
    xorg.libXcursor
    xorg.libXi
    xorg.libX11
  ];

  preBuild = ''
<<<<<<< HEAD
=======
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps,metainfo}

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    install -m 444 \
        -D $src/assets/io.github.dimtpap.coppwr.desktop \
        -t $out/share/applications
    install -m 444 \
        -D $src/assets/io.github.dimtpap.coppwr.metainfo.xml \
        -t $out/share/metainfo
<<<<<<< HEAD
    install -m 444 \
        -D $src/assets/icon/scalable.svg \
        $out/share/icons/hicolor/scalable/apps/io.github.dimtpap.coppwr.svg
    for size in 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      install -m 444 \
          -D $src/assets/icon/"$size".png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/io.github.dimtpap.coppwr.png
=======
    cp $src/assets/icon/scalable.svg $out/share/icons/hicolor/scalable/apps/io.github.dimtpap.coppwr.svg
    for size in 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      cp $src/assets/icon/"$size".png $out/share/icons/hicolor/"$size"x"$size"/apps/io.github.dimtpap.coppwr.png
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    done
  '';

  postFixup = ''
    patchelf $out/bin/coppwr \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ]
      }
  '';

  meta = {
    description = "Low level control GUI for the PipeWire multimedia server";
    homepage = "https://github.com/dimtpap/coppwr";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ravenz46 ];
    mainProgram = "coppwr";
    platforms = lib.platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
