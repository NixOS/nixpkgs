{ fetchFromGitHub, libgit2, ...}:

libgit2.overrideAttrs (oldAttrs: {
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DUSE_BUNDLED_ZLIB=ON"
    "-DUSE_ICONV=OFF"
    "-DBUILD_CLAR=OFF"
    "-DUSE_SSH=OFF"
    "-DUSE_HTTPS=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DUSE_EXT_HTTP_PARSER=OFF"
  ];
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "libgit2";
    rev = "bb77509f4436901f3958e30272026f63d2247d7d";
    sha256 = "06iypr0sc6g11xipwfbgm6f039d4qy9krmwb3zww8k4y004s5jcv";
  };
})
