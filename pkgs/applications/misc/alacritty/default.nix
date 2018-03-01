{ stdenv,
  fetchgit,
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
  libXrandr,
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
    libXrandr
    libXi
  ];
in buildRustPackage rec {
  name = "alacritty-unstable-${version}";
  version = "2018-01-31";

  # At the moment we cannot handle git dependencies in buildRustPackage.
  # This fork only replaces rust-fontconfig/libfontconfig with a git submodules.
  src = fetchgit {
    url = https://github.com/Mic92/alacritty.git;
    rev = "rev-${version}";
    sha256 = "0jc8haijd6f8r5fqiknrvqnwc9q4cp93852lr2p7zak7dv29v45p";
    fetchSubmodules = true;
  };

  cargoSha256 = "0023jpc6krilmp5wzbbwapxafsi6m1k13mvjh4zlvls1nyyhk808";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkgconfig
  ];

  buildInputs = rpathLibs;

  postPatch = ''
    substituteInPlace copypasta/src/x11.rs \
      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
  '';

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty

    install -D Alacritty.desktop $out/share/applications/alacritty.desktop

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
