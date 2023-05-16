{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, pcre2
=======
, fetchpatch
, pcre
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, uthash
, lua5_4
, makeWrapper
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "mle";
<<<<<<< HEAD
  version = "1.7.2";
=======
  version = "1.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "adsr";
    repo = "mle";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "0rkk7mh6w5y1lrbdv7wmxdgl5cqzpzw0p26adazkqlfdyb6wbj9k";
  };

=======
    sha256 = "1nhd00lsx9v12zdmps92magz76c2d8zzln3lxvzl4ng73gbvq3n0";
  };

  # Bug fixes found after v1.5.0 release
  patches = [
    (fetchpatch {
      name = "skip_locale_dep_test.patch";
      url = "https://github.com/adsr/mle/commit/e4dc4314b02a324701d9ae9873461d34cce041e5.patch";
      sha256 = "sha256-j3Z/n+2LqB9vEkWzvRVSOrF6yE+hk6f0dvEsTQ74erw=";
    })
    (fetchpatch {
      name = "fix_input_trail.patch";
      url = "https://github.com/adsr/mle/commit/bc05ec0eee4143d824010c6688fce526550ed508.patch";
      sha256 = "sha256-dM63EBDQfHLAqGZk3C5NtNAv23nCTxXVW8XpLkAeEyQ=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Fix location of Lua 5.4 header and library
  postPatch = ''
    substituteInPlace Makefile --replace "-llua5.4" "-llua";
    substituteInPlace mle.h    --replace "<lua5.4/" "<";
    patchShebangs tests/*
  '';

<<<<<<< HEAD
  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = [ pcre2 uthash lua5_4 ];
=======
  # Use select(2) instead of poll(2) (poll is returning POLLINVAL on macOS)
  # Enable compiler optimization
  CFLAGS = "-DTB_OPT_SELECT -O2";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = [ pcre uthash lua5_4 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;

  installFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    installManPage mle.1
  '';

  meta = with lib; {
    description = "Small, flexible, terminal-based text editor";
    homepage = "https://github.com/adsr/mle";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ adsr ];
  };
}
