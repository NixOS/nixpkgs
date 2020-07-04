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
    rev = "tag-005f77dca6dbe8788e55139fa1199fc94cc04f9a";
    sha256 = "1h5bnisk4ljdpfzlv8g41m8js9841xyjhfywc5cn8pmyv58c50il";
  };
})
