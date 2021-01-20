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
    rev = "tag-82cefe2b42300224ad3c148f8b1a569757cc617a";
    sha256 = "1vhnqynqyxizzkq1h5dfjm75f0jm5637jh0gypwqqz2yjqrscza0";
  };
})
