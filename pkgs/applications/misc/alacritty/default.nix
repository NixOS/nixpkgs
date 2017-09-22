{ stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  makeWrapper,
  expat,
  pkgconfig,
  freetype,
  fontconfig,
  libX11,
  gperf,
  libXcursor,
  libXxf86vm,
  libXi,
  xclip }:

with rustPlatform;

let
  rpathLibs = [
    expat
    freetype
    fontconfig
    libX11
    libXcursor
    libXxf86vm
    libXi
  ];
in

buildRustPackage rec {
  name = "alacritty-unstable-2017-09-02";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "22fa4260fc9210fbb5288090df79c92e7b3788e4";
    sha256 = "0jjvvm0fm25p1h1rgfqlnhq4bwrjdxpb2pgnmpik9pl7qwy3q7s1";
  };

  depsSha256 = "19lrj4i6vzmf22r6xg99zcwvzjpiar8pqin1m2nvv78xzxx5yvgb";

  buildInputs = [
    cmake
    makeWrapper
    pkgconfig
  ] ++ rpathLibs;

  postPatch = ''
    substituteInPlace copypasta/src/x11.rs \
      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    for f in $(find target/release -maxdepth 1 -type f); do
      cp $f $out/bin
    done;
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty

    mkdir -p $out/share/applications
    cp Alacritty.desktop $out/share/applications/alacritty.desktop

    runHook postInstall
  '';

  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "GPU-accelerated terminal emulator";
    homepage = https://github.com/jwilm/alacritty;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
