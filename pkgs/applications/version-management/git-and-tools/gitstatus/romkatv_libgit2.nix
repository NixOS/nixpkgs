{ fetchFromGitHub, libgit2, ...}:

libgit2.overrideAttrs (oldAttrs: {
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DBUILD_CLAR=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DREGEX_BACKEND=builtin"
    "-DUSE_BUNDLED_ZLIB=ON"
    "-DUSE_GSSAPI=OFF"
    "-DUSE_HTTPS=OFF"
    "-DUSE_HTTP_PARSER=builtin"  # overwritten from libgit2
    "-DUSE_NTLMCLIENT=OFF"
    "-DUSE_SSH=OFF"
    "-DZERO_NSEC=ON"
  ];
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "libgit2";
    rev = "tag-5860a42d19bcd226cb6eff2dcbfcbf155d570c73";
    sha256 = "sha256-OdGLNGOzXbWQGqw5zYM1RhU4Z2yRXi9cpAt7Vn9+j5I=";
  };
})
