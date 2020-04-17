{ fetchFromGitHub, libgit2, ...}:

libgit2.overrideAttrs (oldAttrs: {
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DBUILD_CLAR=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DREGEX_BACKEND=builtin"
    "-DUSE_BUNDLED_ZLIB=ON"
    "-DUSE_HTTPS=OFF"
    "-DUSE_HTTP_PARSER=builtin"  # overwritten from libgit2
    "-DUSE_ICONV=OFF"
    "-DUSE_SSH=OFF"
    "-DZERO_NSEC=ON"
  ];
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "libgit2";
    rev = "bb77509f4436901f3958e30272026f63d2247d7d";
    sha256 = "06iypr0sc6g11xipwfbgm6f039d4qy9krmwb3zww8k4y004s5jcv";
  };
})
