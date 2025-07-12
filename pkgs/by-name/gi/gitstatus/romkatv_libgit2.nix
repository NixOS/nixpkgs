{ fetchFromGitHub, libgit2, ... }:

libgit2.overrideAttrs (oldAttrs: {
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DBUILD_CLAR=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DREGEX_BACKEND=builtin"
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
    rev = "tag-2ecf33948a4df9ef45a66c68b8ef24a5e60eaac6";
    hash = "sha256-Bm3Gj9+AhNQMvkIqdrTkK5D9vrZ1qq6CS8Wrn9kfKiw=";
  };

  # this is a heavy fork of the original libgit2
  # the original checkPhase does not work for this fork
  doCheck = false;

  patches = [ ];
})
