{ lib
, stdenv
, fetchFromGitHub
, fetchzip
, fetchurl
, fetchgit
, linkFarm
, runCommand
, runCommandLocal
, zstd
, cmake
, ninja
, pkg-config
, zig
, gtk4
, libadwaita
, cairo
, pango
, gdk-pixbuf
, graphene
, harfbuzz
, vulkan-headers
, vulkan-loader
, glib
, expat
, libxdmcp
, libsysprof-capture
, pcre2
, wrapGAppsHook4
}:

let
  ghosttySrc = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    rev = "b0f8276658fbcc75318d2125d40146074a3fc505";
    hash = lib.fakeHash;
  };

  zigDepsRaw = import "${ghosttySrc}/build.zig.zon.nix" {
    inherit lib linkFarm fetchzip fetchurl fetchgit zstd;
    inherit runCommandLocal;
    zig_0_15 = zig;
  };

  zigDeps = runCommand "zig-global-cache" { } ''
    mkdir -p "$out/p"
    for dep in "${zigDepsRaw}/"*; do
      if [ -e "$dep" ]; then
        ln -s "$(readlink -f "$dep")" "$out/p/$(basename "$dep")"
      fi
    done
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shellbar";
  version = "1.9.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "rendergraf";
    repo = "shellbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2gVUEVS2Kw3HokJwifztcDE7Nhp8E4+exAK9p7X+1FQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    zig
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    cairo
    pango
    gdk-pixbuf
    graphene
    harfbuzz
    vulkan-headers
    vulkan-loader
    glib
    expat
    libxdmcp
    libsysprof-capture
    pcre2
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(ZIG_NEED_DOWNLOAD TRUE)' 'set(ZIG_NEED_DOWNLOAD TRUE CACHE BOOL "Whether to download Zig")'
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DFETCHCONTENT_SOURCE_DIR_GHOSTTY=${ghosttySrc}"
    "-DZIG_EXECUTABLE=${zig}/bin/zig"
    "-DZIG_NEED_DOWNLOAD=FALSE"
  ];

  ZIG_GLOBAL_CACHE_DIR = "${zigDeps}";

  meta = with lib; {
    description = "A Ghostty-like terminal emulator with a configurable command toolbar";
    homepage = "https://github.com/rendergraf/shellbar";
    license = licenses.mit;
    mainProgram = "shellbar";
    maintainers = with maintainers; [ rendergraf ];
    platforms = platforms.linux;
  };
})
