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
  name = "alacritty-unstable-2017-07-25";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "49c73f6d55e5a681a0e0f836cd3e9fe6af30788f";
    sha256 = "0h5hrb2g0fpc6xn94hmvxjj21cqbj4vgqkznvd64jl84qbyh1xjl";
  };

  depsSha256 = "1pbb0swgpsbd6x3avxz6fv3q31dg801li47jibz721a4n9c0rssx";

  buildInputs = [
    cmake
    makeWrapper
    xclip
    pkgconfig
  ] ++ rpathLibs;

  patchPhase = ''
    substituteInPlace copypasta/src/x11.rs \
      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find target/release -maxdepth 1 -type f); do
      cp $f $out/bin
    done;
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
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
