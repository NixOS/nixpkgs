{ fetchFromGitHub, libgit2, ... }:

libgit2.overrideAttrs (oldAttrs: {
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DBUILD_CLAR=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DREGEX_BACKEND=builtin"
    "-DUSE_BUNDLED_ZLIB=ON"
    "-DUSE_GSSAPI=OFF"
    "-DUSE_HTTPS=OFF"
    "-DUSE_HTTP_PARSER=builtin" # overwritten from libgit2
    "-DUSE_NTLMCLIENT=OFF"
    "-DUSE_SSH=OFF"
    "-DZERO_NSEC=ON"
  ];

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "libgit2";
    rev = "tag-0ad3d776aa86dd607dc86dcd7f77ad3ed7ebec61";
    sha256 = "sha256-mXCmspM3fqI14DF9sAIMH5vGdMMjWkdDjdME4EiQuqY=";
  };

  patches = [ ];
})
