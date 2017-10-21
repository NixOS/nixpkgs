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
  name = "alacritty-unstable-2017-10-17";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "5ac42bb13bc68c5cbc44869dc9fc9ac19402a6e6";
    sha256 = "0h37x12r33xwz9vf1n8y24c0ph5w17lhkpfi5q6lbpgidvbs6fyx";
  };

  cargoSha256 = "0w3j92kd27pny37pfvlv6qsnbb1lgphmfbhvvng0z96r2b1wjviz";

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
    broken = true;
    description = "GPU-accelerated terminal emulator";
    homepage = https://github.com/jwilm/alacritty;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
