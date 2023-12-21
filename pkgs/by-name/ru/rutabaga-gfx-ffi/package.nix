{ aemu
, rustPlatform
, fetchgit
, pkg-config
, gfxstream
, libdrm
, lib
}:

rustPlatform.buildRustPackage {
  pname = "rutabaga_gfx_ffi";
  version = "unstable-2023-12-20";

  src = fetchgit {
    url = "https://chromium.googlesource.com/crosvm/crosvm";
    rev = "46279a0c03f8892f22ebd8c0dc19e4a6dc8aac41";
    hash = "sha256-xHT3uWPGVqXFr5G08jliti5RXSsZLb6fH8eiy8cyzNY=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-rutabaga_gfx-don-t-clone-wayland-memfd-file-descript.patch
    ./0002-rutabaga_gfx-super-ugly-workaround-to-get-private-ke.patch
    ./0003-rutabaga_gfx-fix-stale-cross-domain-keymap-resources.patch
  ];

  buildPhase = ''
    cd rutabaga_gfx/ffi
    make build
  '';

  installPhase = ''
    make install prefix=$out
  '';

  cargoHash = "sha256-lOC0bK/nePSQCkxKHjD6xAVyvx0xGRFm/5+2jEKfwQs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gfxstream aemu libdrm ];

  meta = with lib; {
    description = "FFI bindings for rutabaga_gfx";
    homepage = "https://crosvm.dev/book/appendix/rutabaga_gfx.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 ];
  };
}
